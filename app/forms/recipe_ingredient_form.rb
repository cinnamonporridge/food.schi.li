class RecipeIngredientForm
  include ActiveModel::Model
  include Rails.application.routes.url_helpers

  delegate :persisted?, :id, to: :ingredient

  attr_reader :recipe, :ingredient, :portion_id, :measure, :amount_in_measure

  validates :portion_id, presence: true
  validates :amount_in_measure, presence: true, numericality: { greater_than: 0 }
  validates :measure, presence: true

  validate :portion_exists?

  def initialize(args = {})
    @ingredient         = args[:ingredient]
    @recipe             = @ingredient.recipe
    @portion_id         = args[:portion_id] || ingredient.portion&.id
    @measure            = args[:measure] || ingredient.measure
    @amount_in_measure  = args[:amount_in_measure] || to_amount_in_measure(ingredient.amount)
  end

  def values
    {
      portion: find_portion,
      amount: amount_in_unit,
      measure: measure
    }
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'RecipeIngredient')
  end

  def action_url
    if persisted?
      recipe_ingredient_path(recipe, ingredient)
    else
      recipe_ingredients_path(recipe)
    end
  end

  private

  def portion_exists?
    find_portion.present?
  end

  def find_portion
    @portion ||= Portion.find_by(id: portion_id)
  end

  def amount_in_unit
    return (amount_in_measure.to_f * find_portion.amount) if measure_in_pieces?
    amount_in_measure
  end

  def to_amount_in_measure(amount)
    return (amount.to_f / find_portion.amount).round(3) if measure_in_pieces?
    amount
  end

  def measure_in_pieces?
    measure == 'piece'
  end
end
