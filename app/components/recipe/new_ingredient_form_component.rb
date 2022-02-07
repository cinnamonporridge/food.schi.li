class Recipe::NewIngredientFormComponent < ViewComponent::Base
  attr_reader :user, :params

  delegate :recipe, to: :@recipe_ingredient

  def initialize(user:, recipe_ingredient:, params:)
    @user = user
    @params = params
    @food = find_or_initialize_food
    @recipe_ingredient = prepare_recipe_ingredient(recipe_ingredient, @food)
  end

  def food_search_form
    @food_search_form ||= FoodSearchForm.new(@food, params_with_action_url)
  end

  def recipe_ingredient_form
    @recipe_ingredient_form ||= RecipeIngredientForm.new(@recipe_ingredient, params)
  end

  private

  def params_with_action_url
    params.merge(action_url: new_recipe_ingredient_path(@recipe_ingredient.recipe))
  end

  def user_foods
    Food.of_user(user)
  end

  def find_or_initialize_food
    find_food_by_food_name_params || user.foods.new
  end

  def find_food_by_food_name_params
    return if params[:food_name].blank?

    user_foods.find_by(name: params[:food_name])
  end

  def prepare_recipe_ingredient(recipe_ingredient, food)
    recipe_ingredient.tap do |ri|
      ri.food = food
    end
  end
end
