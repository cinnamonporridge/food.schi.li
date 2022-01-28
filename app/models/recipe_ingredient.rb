class RecipeIngredient < ApplicationRecord
  include NutritionFacts

  delegate :user, to: :recipe
  delegate :vegan?, to: :portion

  belongs_to :portion
  belongs_to :recipe

  scope :of_user, ->(user) { joins(:recipe).where(recipe: { user: } ) }
  scope :of_active_recipes, ->() { joins(:recipe).where(recipe: { archived_at: nil }) }

  has_one :food, through: :portion

  validates :amount, presence: true

  enum measure: { unit: 'unit', piece: 'piece' }, _prefix: :measure

  def to_nutritions_table_row
    [
      portion.decorate.name_with_food,
      decorate.display_kcal,
      decorate.display_carbs,
      decorate.display_protein,
      decorate.display_fat
    ]
  end
end
