class Ingredient < ApplicationRecord
  include NutritionFacts

  belongs_to :portion
  belongs_to :recipe

  has_one :nutrition, through: :portion

  validates :portion, presence: true
  validates :recipe, presence: true
  validates :amount, presence: true

  enum measure: { unit: 1, piece: 2 }, _prefix: :measure

  def to_nutritions_table_row
    [
      portion.decorate.name_with_nutrition,
      decorate.display_kcal,
      decorate.display_carbs,
      decorate.display_protein,
      decorate.display_fat
    ]
  end
end
