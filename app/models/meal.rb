class Meal < ApplicationRecord
  include NutritionFacts

  belongs_to :journal_day
  belongs_to :portion
  belongs_to :recipe, optional: true

  has_one :food, through: :portion

  enum measure: { unit: 1, piece: 2 }, _prefix: :measure

  scope :using_food, ->(food) {
    includes(:portion).where(portions: { food: })
  }

  scope :ordered_by_recipe, -> { order(:recipe_id) }

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
