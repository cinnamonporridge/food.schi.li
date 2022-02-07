class Recipe::IngredientsListComponent < ApplicationComponent
  attr_reader :recipe

  def initialize(recipe:)
    @recipe = recipe
    super()
  end

  def recipe_ingredients
    @recipe_ingredients ||= recipe.recipe_ingredients.ordered_by_food_name
  end

  def to_dom_id
    "#{dom_id(recipe)}_ingredients_list"
  end
end
