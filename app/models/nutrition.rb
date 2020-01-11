class Nutrition < ApplicationRecord
  include Searchable

  has_many :portions, dependent: :destroy
  has_one :primary_portion, -> { primary }, class_name: 'Portion', inverse_of: false

  TYPES = %i[kcal carbs carbs_sugar_part protein fat fat_saturated fiber].freeze

  scope :ordered_by_name, -> { order(name: :asc) }

  enum unit: { gram: 1, mililiter: 2 }

  before_destroy :can_be_destroyed, prepend: true

  validates :name, presence: true, uniqueness: true
  validates :unit, presence: true
  validates :kcal, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :carbs, numericality: { greater_than_or_equal_to: 0 }
  validates :carbs_sugar_part, numericality: { greater_than_or_equal_to: 0 }
  validates :protein, numericality: { greater_than_or_equal_to: 0 }
  validates :fat, numericality: { greater_than_or_equal_to: 0 }
  validates :fat_saturated, numericality: { greater_than_or_equal_to: 0 }
  validates :fiber, numericality: { greater_than_or_equal_to: 0 }

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

  def macronutrient_data
    @macronutrient_data ||= MacronutrientDataService.new(
      kcal: kcal,
      carbs: carbs,
      protein: protein,
      fat: fat
    )
  end

  private

  def can_be_destroyed
    check_if_in_recipe
    check_if_in_meal

    throw(:abort) if errors.key?(:base)
  end

  def check_if_in_recipe
    errors.add(:base, "Can't delete nutrition that is still used in a recipe") if in_recipes.any?
  end

  def check_if_in_meal
    errors.add(:base, "Can't delete nutrition that is still used in a meal") if in_meals.any?
  end
end
