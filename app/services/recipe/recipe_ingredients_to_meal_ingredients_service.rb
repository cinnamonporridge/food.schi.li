class Recipe::RecipeIngredientsToMealIngredientsService
  def initialize(recipe:, meal:, servings:)
    @recipe = recipe
    @meal = meal
    @servings = servings
  end

  def to_meal_ingredients
    @recipe.ingredients.map(&method(:to_meal_ingredient))
  end

  private

  def to_meal_ingredient(recipe_ingredient)
    MealIngredient.new(portion: recipe_ingredient.portion,
                       amount: amount_for(recipe_ingredient),
                       measure: recipe_ingredient.measure)
  end

  def copy_ratio
    (@number_of_servings.to_f / @recipe.servings)
  end

  def amount_for(recipe_ingredient)
    if recipe_ingredient.measure_piece?
      (recipe_ingredient.amount * copy_ratio).round(2)
    else
      (recipe_ingredient.amount * copy_ratio).round(4)
    end
  end
end
