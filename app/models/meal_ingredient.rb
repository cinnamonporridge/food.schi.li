class MealIngredient < ApplicationRecord
  include NutritionFacts

  delegate :user, to: :meal

  belongs_to :meal
  belongs_to :portion
  has_one :food, through: :portion

  enum measure: { unit: "unit", piece: "piece" }, _prefix: :measure

  scope :of_user, ->(user) { joins(meal: { journal_day: :user }).where(meal: { journal_days: { user: } }) }
  scope :of_recipes, -> { joins(:meal).where(meal: { consumable_type: "Recipe" }) }
  scope :of_portions, -> { joins(:meal).where(meal: { consumable_type: "Portion" }) }
  scope :using_food, ->(food) { includes(:portion).where(portions: { food: }) }
  scope :ordered_by_recipe, -> { order(:recipe_id) }
  scope :ordered_by_food_name_and_amount, -> {
    includes(portion: :food).order("foods.name ASC, portions.amount ASC")
  }
  scope :of_recipe, ->(recipe) { where(recipe:) }
end
