class RecipeIngredient < ApplicationRecord
  include NutritionFacts

  delegate :user, to: :recipe
  delegate :vegan?, to: :portion

  belongs_to :portion
  belongs_to :recipe

  scope :of_user, ->(user) { joins(:recipe).where(recipe: { user: }) }
  scope :of_active_recipes, -> { joins(:recipe).where(recipe: { archived_at: nil }) }
  scope :ordered_by_food_name, -> { joins(portion: :food).order("foods.name ASC") }

  has_one :food, through: :portion

  validates :amount, presence: true

  enum :measure, { unit: "unit", piece: "piece" }, prefix: :measure
end
