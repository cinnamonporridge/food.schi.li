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

  def macronutrient_data
    @macronutrient_data ||= MacronutrientDataService.new(
      kcal: kcal,
      carbs: carbs,
      protein: protein,
      fat: fat
    )
  end

  def macronutrient_data_serving
    @macronutrient_data_serving ||= MacronutrientDataService.new(
      kcal: decorate.serving(:kcal),
      carbs: decorate.serving(:carbs),
      protein: decorate.serving(:protein),
      fat: decorate.serving(:fat)
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
        decorate.display_kcal,
        decorate.display_carbs,
        decorate.display_protein,
        decorate.display_fat
      ]],
      per_serving: [[
        'Per serving',
        decorate.serving(:kcal),
        decorate.serving(:carbs),
        decorate.serving(:protein),
        decorate.serving(:fat)
      ]]
    }
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
