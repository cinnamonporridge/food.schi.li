class DayPartitionForm < ApplicationForm
  delegate :user, to: :object

  validates :name, presence: true

  def save
    return unless valid?

    object.name = name
    object.position = position

    DayPartition::SaveService.new(object).save
  end

  def destroy
    DayPartition::SaveService.new(object).destroy
  end

  def name
    params[:name] || object.name
  end

  def position
    params[:position] || object.position
  end

  def move_to_position_options
    @move_to_position_options ||= build_insert_at_position_options
  end

  private

  def build_insert_at_position_options
    user_day_partitions_options.push(['At the end', -1])
  end

  def user_day_partitions_options
    user.day_partitions.ordered_by_position.map do |day_partition|
      [
        "#{day_partition.position} - #{day_partition.name}",
        day_partition.position
      ]
    end
  end
end
