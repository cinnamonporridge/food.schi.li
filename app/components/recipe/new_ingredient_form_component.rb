class Recipe::NewIngredientFormComponent < ViewComponent::Base
  attr_reader :params, :recipe

  delegate :user, to: :recipe

  def initialize(recipe:, params:)
    @recipe = recipe
    @params = params
    super()
  end

  def food_search_form
    @food_search_form ||= FoodSearchForm.new(params_with_action_url, user)
  end

  def recipe_ingredient_form
    @recipe_ingredient_form ||= RecipeIngredientForm.new(recipe_ingredient, params)
  end

  private

  def recipe_ingredient
    @recipe_ingredient ||= prepare_recipe_ingredient
  end

  def params_with_action_url
    params.merge(action_url:)
  end

  def action_url
    Rails.application.routes.url_helpers.new_recipe_ingredient_path(recipe)
  end

  def prepare_recipe_ingredient
    recipe.recipe_ingredients.new do |recipe_ingredient|
      recipe_ingredient.food = food_search_form.food
    end
  end
end
