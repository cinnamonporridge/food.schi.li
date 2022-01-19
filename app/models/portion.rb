class Portion < ApplicationRecord
  include NutritionFacts

  PRIMARY_AMOUNT = 100

  belongs_to :food
  has_many :ingredients, dependent: :restrict_with_exception
  has_many :recipes, through: :ingredients, dependent: :restrict_with_exception
  has_many :meals, as: :consumable
  has_many :meal_ingredients, dependent: :restrict_with_exception

  scope :ordered_by_amount, -> { order(amount: :asc) }
  scope :ordered_by_food_name_and_amount, -> {
    includes(:food).order('foods.name ASC, portions.amount ASC')
  }
  scope :primary, -> { where(amount: PRIMARY_AMOUNT) }
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

  def deleteable?
    ingredients.none? && meal_ingredients.none?
  end
end
