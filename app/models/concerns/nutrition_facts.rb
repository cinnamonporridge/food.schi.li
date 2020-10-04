module NutritionFacts
  extend ActiveSupport::Concern

  COLUMNS = %i[kcal carbs carbs_sugar_part protein fat fat_saturated fiber].freeze

  included do
    validates :kcal, numericality: { greater_than_or_equal_to: 0, only_integer: true }
    validates :carbs, numericality: { greater_than_or_equal_to: 0 }
    validates :carbs_sugar_part, numericality: { greater_than_or_equal_to: 0 }
    validates :protein, numericality: { greater_than_or_equal_to: 0 }
    validates :fat, numericality: { greater_than_or_equal_to: 0 }
    validates :fat_saturated, numericality: { greater_than_or_equal_to: 0 }
    validates :fiber, numericality: { greater_than_or_equal_to: 0 }
  end
end
