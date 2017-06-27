class Nutrition < ApplicationRecord
  has_many :portions

  TYPES = %i(kcal carbs carbs_sugar_part protein fat fat_saturated fiber)

  scope :ordered_by_name, -> { order(name: :asc) }

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_numericality_of :kcal             ,  greater_than_or_equal_to: 0, only_integer: true
  validates_numericality_of :carbs            ,  greater_than_or_equal_to: 0
  validates_numericality_of :carbs_sugar_part ,  greater_than_or_equal_to: 0
  validates_numericality_of :protein          ,  greater_than_or_equal_to: 0
  validates_numericality_of :fat              ,  greater_than_or_equal_to: 0
  validates_numericality_of :fat_saturated    ,  greater_than_or_equal_to: 0
  validates_numericality_of :fiber            ,  greater_than_or_equal_to: 0
end
