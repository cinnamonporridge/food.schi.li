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

  def initialize(user:)
    @user = user
  end

  def update_all!
    ActiveRecord::Base.transaction do
      TABLE_NAME_TO_KLASS_MAPPING.keys.map(&method(:do_update!))
    end
  end

  def update!(*table_names)
    ActiveRecord::Base.transaction do
      Array(table_names).map(&method(:do_update!))
    end
  end

  private

  def do_update!(table_name)
    TABLE_NAME_TO_KLASS_MAPPING[table_name].new(user:).call!
  end
end
