class DayPartitionForm < ApplicationForm
  delegate :user, to: :object
  delegate :destroy, to: :save_service

  validates :name, presence: true

  def save
    return unless valid?

    object.name = name
    object.position = position

    save_service.save || merge_errors_and_return_false!(save_service.day_partition)
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

  def save_service
    @save_service ||= DayPartition::SaveService.new(object)
  end

  def build_insert_at_position_options
    DayPartitionDecorator.day_partition_options_for_user(user).push(['At the end', -1])
  end
end
