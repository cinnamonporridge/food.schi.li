class DayPartition::SaveService
  attr_reader :day_partition

  delegate :user, to: :day_partition

  def initialize(day_partition)
    @day_partition = day_partition
  end

  def save
    return unless @day_partition.valid?

    DayPartition.transaction do
      execute explode_positions_sql
      upsert_day_partition
      execute normalize_positions_sql
    end
  end

  def destroy
    DayPartition.transaction do
      @day_partition.destroy
      execute normalize_positions_sql
    end
  end

  private

  def execute(sql)
    ActiveRecord::Base.connection.execute(sql)
  end

  def upsert_day_partition
    @day_partition.position = (@day_partition.position * explode_factor) - 1
    @day_partition.save
  end

  def max_position
    @max_position ||= user.day_partitions.maximum(:position) + 1
  end

  def explode_factor
    @explode_factor ||= max_position * 10
  end

  def normalize_positions_sql
    <<~SQL.squish
      UPDATE day_partitions dp
         SET position = t.target_position
        FROM ( SELECT id
                    , rank() OVER (ORDER BY position) AS target_position
                 FROM day_partitions
                WHERE user_id = #{user.id}
                  AND position != #{DayPartition::DEFAULT_POSITION} ) t
       WHERE dp.id = t.id
    SQL
  end

  def explode_positions_sql
    <<~SQL.squish
      UPDATE day_partitions dp
         SET position = position * #{explode_factor}
       WHERE position != #{DayPartition::DEFAULT_POSITION}
    SQL
  end
end
