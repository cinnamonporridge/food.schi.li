class Meal < ApplicationRecord
  belongs_to :journal_day
  belongs_to :day_partition, optional: true
  belongs_to :consumable, polymorphic: true

  has_many :meal_ingredients, dependent: :destroy

  scope :of_consumable_type, ->(consumable_type) { where(consumable_type: consumable_type.to_s) }
  scope :of_recipes, -> { of_consumable_type(Recipe) }
  scope :of_portions, -> { of_consumable_type(Portion) }
end
