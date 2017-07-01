class Ingredient < ApplicationRecord
  belongs_to :portion
  belongs_to :recipe

  validates :portion, presence: true
  validates :recipe, presence: true
  validates :amount, presence: true

  Nutrition::TYPES.each do |name|
    define_method :"total_#{name}" do
      send(:total_of_sustenance, name)
    end
  end

  def nutrition
    portion.nutrition
  end

  private

  def total_of_sustenance(name)
    return 0.0 unless portion.present?
    quantity * portion.send("total_#{name}".to_sym)
  end
end
