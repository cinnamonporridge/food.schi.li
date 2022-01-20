class MealIngredientForm < ApplicationForm
  validates :amount, :measure, presence: true
  validates_numericality_of :amount_in_measure, greater_than: 0

  def amount_in_measure
    @amount_in_measure ||= @params[:amount_in_measure] || meal_ingredient_amount_in_measure
  end

  def measure
    @measure ||= @params[:measure] || meal_ingredient_measure
  end

  def save
    return unless valid?

    object.amount = amount
    object.measure = measure

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

  def meal_ingredient_amount_in_measure
    return (object.amount.to_f / object.portion.amount).round(3) if measure_in_pieces?

    object.amount
  end

  def meal_ingredient_measure
    object.measure
  end
end
