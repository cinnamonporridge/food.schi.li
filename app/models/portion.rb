class Portion < ApplicationRecord
  PRIMARY_AMOUNT = 100

  belongs_to :nutrition
  has_many :ingredients
  has_many :recipes, through: :ingredients

  scope :ordered_by_amount, -> { order(amount: :asc) }
  scope :ordered_by_nutrition_name_and_amount, -> {
    includes(:nutrition).order("nutritions.name ASC, portions.amount ASC")
  }
  scope :primary, -> { where(amount: PRIMARY_AMOUNT) }

  validates_presence_of :name
  validates_presence_of :amount
  validates_uniqueness_of :name, scope: :nutrition
  validates_uniqueness_of :amount, scope: :nutrition
  validates_numericality_of :amount, greater_than: 0, only_integer: true

  def primary?
    amount == PRIMARY_AMOUNT
  end
end
