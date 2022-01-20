class RecipeMeal::IngredientForm < ApplicationForm
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

  def save
    return unless valid?

    object.assign_attributes(portion:, amount:, measure:)

    super
  end

  private

  def measure_in_pieces?
    measure == 'piece'
  end

  def amount
    return (amount_in_measure.to_f * object.portion.amount) if measure_in_pieces?

    amount_in_measure
  end

  def meal_ingredient_portion_name
    PortionDecorator.portions_collection_with_id
                    .find { |element| element.last == object.portion_id }
                    &.first
  end

  def meal_ingredient_amount_in_measure
    return (object.amount.to_f / object.portion.amount).round(3) if measure_in_pieces?

    object.amount
  end

  def meal_ingredient_measure
    object.measure
  end

  def portion_id
    find_portion_id_by_name(portion_name)
  end

  def portion
    @portion ||= Portion.find_by(id: portion_id)
  end

  def find_portion_id_by_name(portion_name)
    PortionDecorator.portions_collection_with_id
                    .find { |element| element.first == portion_name }
                    &.last
  end

  def portion_exists
    return if portion.present?

    errors.add(:portion_name, 'does not exist')
  end
end


