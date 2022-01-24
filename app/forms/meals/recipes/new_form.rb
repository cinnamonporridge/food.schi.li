class Meals::Recipes::NewForm < ApplicationForm
  PERMITTED_PARAMS = %i[recipe_name servings day_partition_id].freeze

  validates_numericality_of :servings, greater_than: 0
  validate :recipe_exists

  def recipe_name
    @params[:recipe_name]
  end

  def servings
    @params[:servings] || 1
  end

  def day_partition_id
    @params[:day_partition_id]
  end

  def save
    return unless valid?

    object.consumable = recipe
    object.day_partition = day_partition
    build_meal_ingredients.each do |meal_ingredient|
      object.meal_ingredients << meal_ingredient
    end

    super
  end

  def recipe_name_datalist_options
    JournalDayRecipeDecorator.recipes_collection(user)
  end

  def day_partition_options
    @day_partition_options ||= DayPartitionDecorator.day_partition_options_for_user(user)
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'JournalDay::Meal')
  end

  private

  def user
    @user ||= object.journal_day.user
  end

  def recipe
    @recipe ||= user.recipes.find_by(id: recipe_id)
  end

  def day_partition
    @day_partition ||= user.day_partitions.find_by(id: day_partition_id&.to_i) || user.default_day_partition
  end

  def recipe_id
    JournalDayRecipeDecorator.recipes_collection_with_id(user)
                             .find { |form_recipe_name, _id| form_recipe_name == recipe_name }
                             &.last
  end

  def recipe_exists
    errors.add(:recipe_name, 'Selected recipe does not exist') if recipe.nil?
  end

  def build_meal_ingredients
    Recipe::RecipeIngredientsToMealIngredientsService.new(recipe:, meal: object, servings:).to_meal_ingredients
  end
end
