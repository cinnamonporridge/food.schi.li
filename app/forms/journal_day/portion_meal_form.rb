class JournalDay::PortionMealForm < ApplicationForm
  validates :portion_name, :portion_id, :amount_in_measure, :measure, presence: true
  validates_numericality_of :amount_in_measure, greater_than: 0
  validate :portion_exists

  def portion_name
    @params[:portion_name]
  end

  def measure
    @params[:measure]
  end

  def amount_in_measure
    @params[:amount_in_measure]
  end

  def day_partition_id
    @params[:day_partition_id]
  end

  def save
    return unless valid?

    object.consumable = portion
    object.day_partition = user.day_partitions.find_by(id: day_partition_id)
    object.meal_ingredients << MealIngredient.new(portion:, measure:, amount:)

    super
  end

  def day_partition_options
    @day_partition_options ||= DayPartitionDecorator.day_partition_options_for_user(user)
  end

  private

  def user
    @user ||= object.journal_day.user
  end

  def day_partitions
    @day_partitions ||= user.day_partitions
  end

  def portion_id
    find_portion_id_by_name(portion_name)
  end

  def portion
    @portion ||= Portion.find_by(id: portion_id)
  end

  def amount
    return (amount_in_measure.to_f * portion.amount) if measure_in_pieces?

    amount_in_measure
  end

  def find_portion_id_by_name(portion_name)
    PortionDecorator.portions_collection_with_id
                    .find { |element| element.first == portion_name }
                    &.last
  end

  def measure_in_pieces?
    measure == 'piece'
  end

  def portion_exists
    return if portion.present?

    errors.add(:portion_name, 'does not exist')
  end

  def portion_name_exists
    errors.add(:portion_name, 'does not exist') if find_portion_id_by_name(portion_name).nil?
  end
end
