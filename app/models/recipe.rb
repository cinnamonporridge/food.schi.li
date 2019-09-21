class Recipe < ApplicationRecord
  has_many :ingredients, dependent: :destroy
  has_many :portions, through: :ingredients

  validates :name, presence: true
  validates :servings, presence: true

  scope :using_nutrition, -> (nutrition) {
    includes(:portions).where(portions: { nutrition: nutrition } )
  }

  scope :ordered_by_name, -> { order(name: :asc) }
  scope :search, ->(query) {
    return unless query.present?

    where('UPPER(name) LIKE UPPER(:query)', query: "%#{query}%")
  }

  Nutrition::TYPES.each do |name|
    define_method :"sum_#{name}" do
      send(:sum_of_sustenance, name)
    end

    define_method(:"serving_#{name}") do
      send("sum_#{name}") / send(:servings)
    end
  end

  def sum_of_sustenance(name)
    ingredients.inject(0.0) { |sum, ingredient| sum += (ingredient.amount * ingredient.nutrition.send("#{name}")) / 100 }
  end

  def macronutrient_data
    @macronutrient_data ||= MacronutrientDataService.new(
      kcal: sum_kcal,
      carbs: sum_carbs,
      protein: sum_protein,
      fat: sum_fat
    )
  end

  def macronutrient_data_serving
    @macronutrient_data ||= MacronutrientDataService.new(
      kcal: serving_kcal,
      carbs: serving_carbs,
      protein: serving_protein,
      fat: serving_fat
    )
  end

  def detect_vegan
    self.vegan = VeganRecipeDetectionService.new(self).vegan?
  end
end
