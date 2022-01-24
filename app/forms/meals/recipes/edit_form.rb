class Meals::Recipes::EditForm < ApplicationForm
  PERMITTED_PARAMS = %i[day_partition_id].freeze

  def day_partition_id
    @params[:day_partition_id] || meal_day_partition_id
  end

  def day_partition_options
    @day_partition_options ||= DayPartitionDecorator.day_partition_options_for_user(user)
  end

  def save
    object.day_partition = day_partition

    super
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'JournalDay::Meal')
  end

  private

  def day_partition
    @day_partition ||= user.day_partitions.find_by(id: day_partition_id&.to_i) || user.default_day_partition
  end

  def meal_day_partition_id
    object.day_partition_id
  end

  def user
    object.journal_day.user
  end
end
