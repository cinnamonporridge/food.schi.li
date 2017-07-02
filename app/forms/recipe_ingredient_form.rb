class RecipeIngredientForm
  include ActiveModel::Model
  delegate :persisted?, :id, to: :ingredient

  attr_reader :ingredient, :portion_id, :measure, :amount_in_measure

  validates_presence_of :portion_id
  validates_presence_of :amount_in_measure
  validates_presence_of :measure
  validates_numericality_of :amount_in_measure, greater_than: 0
  validate :portion_exists?

  def initialize(args = {})
    @ingredient         = args[:ingredient]
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

  def decorate
    @decorator ||= RecipeIngredientFormDecorator.new(self)
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'RecipeIngredient')
  end

  private

  def portion_exists?
    find_portion.present?
  end

  def find_portion
    @portion ||= Portion.find_by(id: portion_id)
  end

  def amount_in_unit
    return (amount_in_measure.to_i * find_portion.amount) if measure_in_pieces?
    amount_in_measure
  end

  def to_amount_in_measure(amount)
    return (amount.to_i / find_portion.amount).round(3) if measure_in_pieces?
    amount
  end

  def measure_in_pieces?
    measure == 'piece'
  end
end
