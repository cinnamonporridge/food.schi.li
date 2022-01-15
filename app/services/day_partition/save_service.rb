class DayPartition::SaveService
  attr_reader :day_partition

  delegate :user, to: :day_partition

  def initialize(day_partition)
    @day_partition = day_partition
  end

  def save
    DayPartition.transaction do
      execute move_away_conflicting_positions_sql
      @day_partition.save
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

  def position_already_taken?
    user.day_partitions
        .where.not(id: day_partition.id)
        .where(position: day_partition.position)
        .one?
  end

  def normalize_positions_sql
    <<~SQL.squish
      UPDATE day_partitions dp
         SET position = t.target_position
        FROM ( SELECT id
                    , rank() OVER (ORDER BY position) AS target_position
                 FROM day_partitions
                WHERE user_id = #{user.id} ) t
       WHERE dp.id = t.id
    SQL
  end

  def move_away_conflicting_positions_sql
    <<~SQL.squish
      UPDATE day_partitions dp
         SET position = position * t.multiplier + 1
        FROM ( SELECT id
                    , max(position) OVER (PARTITION BY user_id) AS multiplier
                 FROM day_partitions
                WHERE user_id = #{user.id}
                  AND position >= #{day_partition.position} ) t
       WHERE dp.id = t.id
    SQL
  end
end
