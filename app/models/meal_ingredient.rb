class MealIngredient < ApplicationRecord
  include NutritionFacts

  belongs_to :meal
  belongs_to :portion
  has_one :food, through: :portion

  enum measure: { unit: 'unit', piece: 'piece' }, _prefix: :measure

  scope :of_user, ->(user) { joins(meal: { journal_day: :user }).where(meal: { journal_days: { user: } }) }
  scope :of_recipes, -> { joins(:meal).where(meal: { consumable_type: 'Recipe' }) }
  scope :of_portions, -> { joins(:meal).where(meal: { consumable_type: 'Portion' }) }
  scope :using_food, ->(food) { includes(:portion).where(portions: { food: }) }
  scope :ordered_by_recipe, -> { order(:recipe_id) }
  scope :ordered_by_food_name_and_amount, -> {
    includes(portion: :food).order('foods.name ASC, portions.amount ASC')
  }
  scope :of_recipe, ->(recipe) { where(recipe:) }

  NutritionFacts::COLUMNS.each do |name|
    define_method :"total_#{name}" do
      send(:total_of_sustenance, name)
    end
  end

  def to_nutritions_table_row
    [
      portion.decorate.name_with_food,
      decorate.display_total_kcal,
      decorate.display_total_carbs,
      decorate.display_total_protein,
      decorate.display_total_fat
    ]
  end

  private

  def total_of_sustenance(name)
    return 0.0 if portion.blank?

    (amount / 100) * food.send(name.to_s.to_sym)
  end
end
