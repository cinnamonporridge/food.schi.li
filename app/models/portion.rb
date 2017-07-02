class Portion < ApplicationRecord
  belongs_to :nutrition
  has_many :ingredients
  has_many :recipes, through: :ingredients

  scope :without, -> (portions) { where.not(id: portions.collect {|p| p.id }) }
  scope :ordered_by_amount, -> { order(amount: :asc) }
  scope :ordered_by_nutrition_name_and_amount, -> {
    includes(:nutrition).order("nutritions.name ASC, portions.amount ASC")
  }

  validates_presence_of :name
  validates_presence_of :amount
  validates_uniqueness_of :name, scope: :nutrition
  validates_uniqueness_of :amount, scope: :nutrition
  validates_numericality_of :amount, greater_than: 0, only_integer: true

  # Nutrition::TYPES.each do |name|
  #   define_method :"total_#{name}" do
  #     send(:total_of_sustenance, name)
  #   end
  # end

  # def total_of_sustenance(name)
  #   amount * nutrition[name.to_sym]
  # end

  def primary?
    amount == 100
  end
end
