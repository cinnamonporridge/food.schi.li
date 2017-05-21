class Recipe < ApplicationRecord
  has_many :ingredients
  has_many :portions, through: :ingredients

  validates :name, presence: true
  validates :servings, presence: true

  accepts_nested_attributes_for :ingredients

  Nutrition::TYPES.each do |name|
    define_method :"sum_#{name}" do
      send(:sum_of_sustenance, name)
    end

    define_method(:"serving_#{name}") do
      send("sum_#{name}") / send(:servings)
    end
  end

  def sum_of_sustenance(name)
    ingredients.inject(0.0) { |sum, ingredient| sum += ingredient.send("total_#{name}") }
  end

  def macro_nutritient_total
    (sum_carbs + sum_protein + sum_fat)
  end
end
