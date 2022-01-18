class MealIngredientPortionForm
  include ActiveModel::Model
  delegate :persisted?, :id, to: :meal_ingredient

  attr_reader :meal_ingredient, :portion_name, :portion_id, :measure, :amount_in_measure, :recipe_id

  validates :portion_name, :portion_id, :amount_in_measure, :measure, presence: true
  validates_numericality_of :amount_in_measure, greater_than: 0
  validate :portion_exists?

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
  def initialize(args = {})
    @meal_ingredient    = args[:meal_ingredient]
    @portion_name       = args[:portion_name] || find_portion_name_by_id(meal_ingredient.portion&.id)
    @portion_id         = find_portion_id_by_name(portion_name) || meal_ingredient.portion&.id
    @measure            = args[:measure] || meal_ingredient.measure
    @amount_in_measure  = args[:amount_in_measure] || to_amount_in_measure(meal_ingredient.amount)
    @recipe_id          = args[:recipe_id] || @meal_ingredient.recipe_id
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity

  def values
    {
      portion: portion,
      amount: amount_in_unit,
      measure: measure,
      recipe_id: recipe_id
    }
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'MealIngredient')
  end

  private

  def portion_exists?
    portion.present?
  end

  def portion
    @portion ||= Portion.find_by(id: portion_id)
  end

  def amount_in_unit
    return (amount_in_measure.to_f * portion.amount) if measure_in_pieces?

    amount_in_measure
  end

  def to_amount_in_measure(amount)
    return (amount.to_f / portion.amount).round(3) if measure_in_pieces?

    amount
  end

  def measure_in_pieces?
    measure == 'piece'
  end

  def find_portion_name_by_id(id)
    PortionDecorator.portions_collection_with_id
                    .find { |element| element.last == id }
                    &.first
  end

  def find_portion_id_by_name(portion_name)
    PortionDecorator.portions_collection_with_id
                    .find { |element| element.first == portion_name }
                    &.last
  end

  def portion_name_exists
    errors.add(:portion_name, 'does not exist') if find_portion_id_by_name(portion_name).nil?
  end
end
