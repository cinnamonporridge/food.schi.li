class JournalDay < ApplicationRecord
  belongs_to :user

  has_many :meals, dependent: :destroy

  validates :date, presence: true
  validates :date, uniqueness: { scope: :user }

  scope :of, ->(user = User.none) { where(user:) }
  scope :ordered_by_date_asc, -> { order(date: :asc) }
  scope :ordered_by_date_desc, -> { order(date: :desc) }

  scope :using_meal_ingredients, ->(meal_ingredients) { where(meal_ingredients:) }

  scope :after_date, ->(date) { where('date > ?', date) }
  scope :before_date, ->(date) { where('date < ?', date) }

  def macronutrient_data
    @macronutrient_data ||= MacronutrientDataService.new(
      kcal:,
      carbs:,
      protein:,
      fat:
    )
  end

  # REFACTOR ME: create NutritionTable and NutritionTableRow
  def to_nutritions_table
    {
      meal_ingredients: meals.map { |meal| meal.meal_ingredients.map(&:to_nutritions_table_row) },
      total: [[
        'Total',
        decorate.kcal,
        decorate.carbs,
        decorate.protein,
        decorate.fat
      ]]
    }
  end
end
