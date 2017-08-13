class Meal < ApplicationRecord
  belongs_to :journal_day
  belongs_to :portion
  belongs_to :recipe, optional: true

  has_one :nutrition, through: :portion

  enum meal_type: { portion: 1, recipe: 2 }, _prefix: :meal_type
  enum measure: { unit: 1, piece: 2 }, _prefix: :measure

  Nutrition::TYPES.each do |name|
    define_method :"total_#{name}" do
      send(:total_of_sustenance, name)
    end
  end

  private

  def total_of_sustenance(name)
    return 0.0 unless portion.present?
    (amount / 100) * nutrition.send("#{name}".to_sym)
  end
end
