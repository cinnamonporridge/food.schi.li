class RecipeIngredientForm
  include ActiveModel::Model

  attr_reader :ingredient, :portion_id, :amount, :unit_or_pieces

  validates_presence_of :portion_id
  validates_presence_of :amount
  validates_presence_of :unit_or_pieces
  validates_numericality_of :amount, greater_than: 0
  validate :portion_exists?

  def initialize(args = {})
    @ingredient     = args[:ingredient]
    @portion_id     = args[:portion_id] || ingredient.portion&.id
    @amount         = args[:amount] || ingredient.amount
    @unit_or_pieces = args[:unit_or_pieces]

    # args.tap do |arg|
    #   @ingredient     = arg[:ingredient]
    #   @portion_id     = arg[:portion_id]
    #   @amount         = arg[:amount]
    #   @unit_or_pieces = arg[:unit_or_pieces]
    # end
  end

  def values
    {
      portion: find_portion,
      amount: amount_in_unit
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
    return (amount * find_portion.amount) if amount_in_pieces?
    amount
  end

  def amount_in_pieces?
    unit_or_pieces == 'unit'
  end
end
