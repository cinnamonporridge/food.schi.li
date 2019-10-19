class Meal < ApplicationRecord
  belongs_to :journal_day
  belongs_to :portion
  belongs_to :recipe, optional: true

  has_one :nutrition, through: :portion

  enum measure: { unit: 1, piece: 2 }, _prefix: :measure

  scope :using_nutrition, ->(nutrition) {
    includes(:portion).where(portions: { nutrition: nutrition })
  }

  scope :ordered_by_recipe, -> { order(:recipe_id) }

  Nutrition::TYPES.each do |name|
    define_method :"total_#{name}" do
      send(:total_of_sustenance, name)
    end
  end

  private

  def total_of_sustenance(name)
    return 0.0 if portion.blank?

    (amount / 100) * nutrition.send(name.to_s.to_sym)
  end
end
