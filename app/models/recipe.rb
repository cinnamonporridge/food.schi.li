class Recipe < ApplicationRecord
  include Searchable

  has_many :ingredients, dependent: :destroy
  has_many :portions, through: :ingredients

  validates :name, presence: true
  validates :servings, presence: true

  scope :using_nutrition, ->(nutrition) {
    includes(:portions).where(portions: { nutrition: nutrition })
  }

  scope :ordered_by_name, -> { order(name: :asc) }

  Nutrition::TYPES.each do |name|
    define_method :"sum_#{name}" do
      send(:sum_of_sustenance, name)
    end

    define_method(:"serving_#{name}") do
      send("sum_#{name}") / send(:servings)
    end
  end

  def sum_of_sustenance(name)
    ingredients.inject(0.0) do |sum, ingredient|
      sum + (ingredient.amount * ingredient.nutrition.send(name.to_s)) / 100
    end
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
    @macronutrient_data_serving ||= MacronutrientDataService.new(
      kcal: serving_kcal,
      carbs: serving_carbs,
      protein: serving_protein,
      fat: serving_fat
    )
  end

  def detect_vegan
    self.vegan = VeganRecipeDetectionService.new(self).vegan?
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def to_nutritions_table
    {
      ingredients: ingredients.map(&:to_nutritions_table_row),
      total: [[
        'Total',
        decorate.sum_kcal,
        decorate.sum_carbs,
        decorate.sum_protein,
        decorate.sum_fat
      ]],
      per_serving: [[
        'Per serving',
        decorate.serving_kcal,
        decorate.serving_carbs,
        decorate.serving_protein,
        decorate.serving_fat
      ]]
    }
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
