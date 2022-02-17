class NutritionFactsService
  attr_reader :record

  TABLE_NAME_TO_KLASS_MAPPING = {
    portions: NutritionFacts::Portions,
    recipe_ingredients: NutritionFacts::RecipeIngredients,
    recipes: NutritionFacts::Recipes,
    meal_ingredients: NutritionFacts::MealIngredients,
    meals: NutritionFacts::Meals,
    journal_days: NutritionFacts::JournalDays
  }.freeze

  TRACKS = {
    food: TABLE_NAME_TO_KLASS_MAPPING.keys,
    portion: TABLE_NAME_TO_KLASS_MAPPING.keys,
    recipe_ingredient: %i[recipe_ingredients recipes],
    recipe: %i[recipes],
    meal_ingredient: %i[meal_ingredients meals journal_days],
    meal: %i[meal_ingredients meals journal_days],
    journal_day: %i[journal_days]
  }.freeze

  def initialize(record)
    @record = record
  end

  def call!
    ActiveRecord::Base.transaction do
      find_track.map(&method(:update!))
    end
  end

  private

  def track_name
    @record.model_name.singular.to_sym
  end

  def find_track
    TRACKS.fetch(track_name)
  end

  def update!(table_name)
    TABLE_NAME_TO_KLASS_MAPPING[table_name].new(record).call!
  end
end
