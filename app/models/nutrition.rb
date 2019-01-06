class Nutrition < ApplicationRecord
  has_many :portions, dependent: :destroy
  has_one :primary_portion, -> { primary }, class_name: 'Portion'

  TYPES = %i(kcal carbs carbs_sugar_part protein fat fat_saturated fiber)

  scope :ordered_by_name, -> { order(name: :asc) }

  enum unit: { gram: 1, mililiter: 2 }

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :unit
  validates_numericality_of :kcal             ,  greater_than_or_equal_to: 0, only_integer: true
  validates_numericality_of :carbs            ,  greater_than_or_equal_to: 0
  validates_numericality_of :carbs_sugar_part ,  greater_than_or_equal_to: 0
  validates_numericality_of :protein          ,  greater_than_or_equal_to: 0
  validates_numericality_of :fat              ,  greater_than_or_equal_to: 0
  validates_numericality_of :fat_saturated    ,  greater_than_or_equal_to: 0
  validates_numericality_of :fiber            ,  greater_than_or_equal_to: 0

  def deleteable?
    in_recipes.none? && in_meals.none?
  end

  def in_recipes
    @in_recipes ||= Recipe.using_nutrition(self)
  end

  def in_meals
    @in_meals ||= Meal.using_nutrition(self)
  end

  def on_journal_days
    @on_journal_days ||= JournalDay.using_meals(in_meals)
  end
end
