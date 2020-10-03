class Portion < ApplicationRecord
  include NutritionFacts

  PRIMARY_AMOUNT = 100

  belongs_to :nutrition
  has_many :ingredients, dependent: :restrict_with_exception
  has_many :recipes, through: :ingredients, dependent: :restrict_with_exception
  has_many :meals, dependent: :restrict_with_exception

  scope :ordered_by_amount, -> { order(amount: :asc) }
  scope :ordered_by_nutrition_name_and_amount, -> {
    includes(:nutrition).order('nutritions.name ASC, portions.amount ASC')
  }
  scope :primary, -> { where(amount: PRIMARY_AMOUNT) }

  validates :name, presence: true
  validates :amount, presence: true
  validates :name, uniqueness: { scope: :nutrition }
  validates :amount, uniqueness: { scope: :nutrition }
  validates :amount, numericality: { greater_than: 0, only_integer: true }

  def primary?
    amount == PRIMARY_AMOUNT
  end
end
