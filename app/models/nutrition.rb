class Nutrition < ApplicationRecord
  has_many :portions

  TYPES = %i(kcal carbs carbs_sugar_part protein fat fat_saturated fiber)

  scope :ordered_by_name, -> { order(name: :asc) }
end
