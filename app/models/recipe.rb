class Recipe < ApplicationRecord
  include Archiveable
  include Searchable

  belongs_to :user

  has_many :recipe_ingredients, dependent: :destroy
  has_many :portions, through: :recipe_ingredients
  has_many :meals, as: :consumable, dependent: :restrict_with_exception

  before_validation :initialize_vegan, if: :new_record?

  validates :name, presence: true
  validates :servings, presence: true

  scope :of_user, ->(user) { where(user:) }
  scope :ordered_by_name, -> { order(name: :asc) }
  scope :using_food, ->(food) {
    includes(:portions).where(portions: { food: })
  }

  def macronutrient_data
    @macronutrient_data ||= MacronutrientDataService.new(kcal:, carbs:, protein:, fat:)
  end

  def macronutrient_data_serving
    @macronutrient_data_serving ||= MacronutrientDataService.new(
      kcal: decorate.serving(:kcal),
      carbs: decorate.serving(:carbs),
      protein: decorate.serving(:protein),
      fat: decorate.serving(:fat)
    )
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def to_nutritions_table
    {
      recipe_ingredients: recipe_ingredients.map(&:to_nutritions_table_row),
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

  private

  def initialize_vegan
    self.vegan = true
  end
end
