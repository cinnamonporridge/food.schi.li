class Portion < ApplicationRecord
  include NutritionFacts

  delegate :user, to: :food

  PRIMARY_AMOUNT = 100

  belongs_to :food
  has_many :recipe_ingredients, dependent: :restrict_with_exception
  has_many :recipes, through: :recipe_ingredients, dependent: :restrict_with_exception
  has_many :meals, as: :consumable, dependent: :restrict_with_exception
  has_many :meal_ingredients, dependent: :restrict_with_exception

  scope :of_user, ->(user) { joins(:food).where(food: { user: }) }
  scope :ordered_by_amount, -> { order(amount: :asc) }
  scope :ordered_by_food_name_and_amount, -> {
    includes(:food).order("foods.name ASC, portions.amount ASC")
  }
  scope :primary, -> { where(amount: PRIMARY_AMOUNT) }
  scope :not_primary, -> { where.not(amount: PRIMARY_AMOUNT) }
  scope :ordered_by_primary_then_name, -> {
    order(Arel.sql("CASE WHEN portions.amount = #{PRIMARY_AMOUNT} THEN 1 ELSE 2 END ASC, portions.name ASC"))
  }

  validates :name, presence: true
  validates :amount, presence: true
  validates :name, uniqueness: { scope: :food }
  validates :amount, uniqueness: { scope: :food }
  validates :amount, numericality: { greater_than: 0, only_integer: true }

  delegate :vegan?, to: :food

  def primary?
    amount == PRIMARY_AMOUNT
  end

  def measure
    primary? ? :unit : :piece
  end

  def deleteable?
    recipe_ingredients.none? && meal_ingredients.none?
  end
end
