class RecipeMealForm < ApplicationForm
  def day_partition_id
    @params[:day_partition_id] || meal_day_partition_id
  end

  def day_partition_options
    @day_partition_options ||= DayPartitionDecorator.day_partition_options_for_user(user)
  end

  def save
    object.day_partition = user.day_partitions.find_by(id: day_partition_id) || User.default_day_partition

    super
  end

  private

  def meal_day_partition_id
    object.day_partition_id
  end

  def user
    object.journal_day.user
  end
end
