class Portion < ApplicationRecord
  belongs_to :nutrition
  has_many :ingredients
  has_many :recipes, through: :ingredients

  scope :ordered_by_multiplier, -> { order(multiplier: :asc) }

  Nutrition::TYPES.each do |name|
    define_method :"total_#{name}" do
      send(:total_of_sustenance, name)
    end
  end

  def total_of_sustenance(name)
    multiplier * nutrition[name.to_sym]
  end

  def primary?
    multiplier == 1.0
  end
end
