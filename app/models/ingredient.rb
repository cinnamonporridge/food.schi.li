class Ingredient < ApplicationRecord
  belongs_to :portion
  belongs_to :recipe

  has_one :nutrition, through: :portion

  validates :portion, presence: true
  validates :recipe, presence: true
  validates :amount, presence: true

  enum measure: { unit: 1, piece: 2 }, _prefix: :measure

  Nutrition::TYPES.each do |name|
    define_method :"total_#{name}" do
      send(:total_of_sustenance, name)
    end
  end

  private

  def total_of_sustenance(name)
    return 0.0 unless portion.present?
    quantity * portion.send("total_#{name}".to_sym)
  end
end
