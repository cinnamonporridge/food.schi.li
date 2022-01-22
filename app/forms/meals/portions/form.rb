class Meals::Portions::Form < ApplicationForm
  PERMITTED_PARAMS = %i[portion_name amount_in_measure measure day_partition_id].freeze

  validates :portion_name, :amount_in_measure, :measure, presence: true
  validates_numericality_of :amount_in_measure, greater_than: 0
  validate :portion_exists

  def portion_name
    @params[:portion_name] || meal_ingredient_portion_name
  end

  def amount_in_measure
    @params[:amount_in_measure] || meal_ingredient_amount_in_measure
  end

  def measure
    @params[:measure] || meal_ingredient_measure
  end

  def day_partition_id
    @params[:day_partition_id] || meal_day_partition_id
  end

  def save
    return unless valid?

    object.consumable = portion
    object.day_partition = user.day_partitions.find_by(id: day_partition_id)
    meal_ingredient.assign_attributes(portion:, measure:, amount:)
    object.meal_ingredients << meal_ingredient

    super
  end

  def day_partition_options
    @day_partition_options ||= DayPartitionDecorator.day_partition_options_for_user(user)
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'JournalDay::Meal')
  end

  private

  def user
    @user ||= object.journal_day.user
  end

  def day_partitions
    @day_partitions ||= user.day_partitions
  end

  def amount
    return (amount_in_measure.to_f * portion.amount) if measure_in_pieces?

    amount_in_measure
  end

  def meal_ingredient
    @meal_ingredient ||= object.meal_ingredients.first_or_initialize
  end

  def meal_ingredient_portion_name
    PortionDecorator.portions_collection_with_id
                    .find { |element| element.last == meal_ingredient.portion_id }
                    &.first
  end

  def meal_ingredient_amount_in_measure
    return (meal_ingredient.amount.to_f / meal_ingredient.portion.amount).round(3) if measure_in_pieces?

    meal_ingredient.amount
  end

  def meal_ingredient_measure
    meal_ingredient.measure
  end

  def meal_day_partition_id
    object.day_partition_id
  end

  def measure_in_pieces?
    measure == 'piece'
  end

  def find_portion_id_by_name(portion_name)
    PortionDecorator.portions_collection_with_id
                    .find { |element| element.first == portion_name }
                    &.last
  end

  def portion_id
    find_portion_id_by_name(portion_name)
  end

  def portion
    @portion ||= Portion.find_by(id: portion_id)
  end

  def portion_exists
    return if portion.present?

    errors.add(:portion_name, 'does not exist')
  end
end
