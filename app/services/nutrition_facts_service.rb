class NutritionFactsService
  attr_reader :user

  TABLE_NAME_TO_KLASS_MAPPING = {
    portions: NutritionFacts::Portions,
    ingredients: NutritionFacts::Ingredients,
    recipes: NutritionFacts::Recipes,
    meal_ingredients: NutritionFacts::MealIngredients,
    meals: NutritionFacts::Meals,
    journal_days: NutritionFacts::JournalDays
  }.freeze

  TRACKS = {
    portions: TABLE_NAME_TO_KLASS_MAPPING.keys,
    recipes: %i[ingredients recipes],
    meals: %i[meal_ingredients meals journal_days]
  }.freeze

  def initialize(user:)
    @user = user
  end

  def update_all!
    update_track!(:portions)
  end

  def update_track!(track_name)
    ActiveRecord::Base.transaction do
      TRACKS[track_name].map(&method(:update!))
    end
  end

  private

  def update!(table_name)
    TABLE_NAME_TO_KLASS_MAPPING[table_name].new(user:).call!
  end
end
