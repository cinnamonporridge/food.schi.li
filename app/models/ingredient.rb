class Ingredient < ApplicationRecord
  include NutritionFacts

  belongs_to :portion
  belongs_to :recipe

  has_one :food, through: :portion

  validates :amount, presence: true

  enum measure: { unit: 'unit', piece: 'piece' }, _prefix: :measure

  delegate :vegan?, to: :portion

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
