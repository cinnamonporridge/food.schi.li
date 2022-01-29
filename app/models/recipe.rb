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
      kcal: decorate.display_kcal_per_serving,
      carbs: decorate.display_carbs_per_serving,
      protein: decorate.display_protein_per_serving,
      fat: decorate.display_fat_per_serving
    )
  end

  private

  def initialize_vegan
    self.vegan = true
  end
end
