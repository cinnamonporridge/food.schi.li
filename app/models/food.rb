class Food < ApplicationRecord
  include Searchable
  include NutritionFacts

  belongs_to :user

  has_many :portions, dependent: :destroy
  has_one :primary_portion, -> { primary }, class_name: 'Portion', inverse_of: false, dependent: :destroy

  scope :ordered_by_name, -> { order(name: :asc) }
  scope :of_user, ->(user) { where(user:) }

  enum unit: { gram: 'gram', mililiter: 'mililiter' }

  before_destroy :can_be_destroyed, prepend: true

  validates :name, presence: true, uniqueness: true
  validates :unit, presence: true

  def deleteable?
    in_recipes.none? && in_meal_ingredients.none?
  end

  def in_recipes
    @in_recipes ||= user.recipes.using_food(self)
  end

  def in_meal_ingredients
    @in_meal_ingredients ||= MealIngredient.using_food(self)
  end

  private

  def can_be_destroyed
    check_if_in_recipe
    check_if_in_meal_ingredient

    throw(:abort) if errors.key?(:base)
  end

  def check_if_in_recipe
    errors.add(:base, "Can't delete food that is still used in a recipe") if in_recipes.any?
  end

  def check_if_in_meal_ingredient
    errors.add(:base, "Can't delete food that is still used in a meal") if in_meal_ingredients.any?
  end
end
