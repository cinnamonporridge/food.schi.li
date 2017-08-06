class Meal < ApplicationRecord
  belongs_to :journal_day
  belongs_to :portion
  belongs_to :recipe, optional: true

  enum meal_type: { portion: 1, recipe: 2 }, _prefix: :meal_type
  enum measure: { unit: 1, piece: 2 }, _prefix: :measure
end
