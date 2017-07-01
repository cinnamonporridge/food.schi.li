class Portion < ApplicationRecord
  belongs_to :nutrition
  has_many :ingredients
  has_many :recipes, through: :ingredients

  scope :ordered_by_amount_in_g_or_ml, -> { order(amount_in_g_or_ml: :asc) }

  validates_presence_of :name
  validates_presence_of :amount_in_g_or_ml
  validates_uniqueness_of :name, scope: :nutrition
  validates_uniqueness_of :amount_in_g_or_ml, scope: :nutrition
  validates_numericality_of :amount_in_g_or_ml, greater_than: 0, only_integer: true

  Nutrition::TYPES.each do |name|
    define_method :"total_#{name}" do
      send(:total_of_sustenance, name)
    end
  end

  def total_of_sustenance(name)
    amount_in_g_or_ml * nutrition[name.to_sym]
  end

  def primary?
    amount_in_g_or_ml == 100
  end
end
