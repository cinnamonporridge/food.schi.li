class CopyRecipeToJournalDayService
  def initialize(recipe, number_of_servings, journal_day)
    @recipe = recipe
    @number_of_servings = number_of_servings
    @journal_day = journal_day
  end

  def call
    copy_recipe_to_journal_day_meal
  end

  private

  def copy_recipe_to_journal_day_meal
    @recipe.ingredients.each do |recipe_ingredient|
      journal_day_meal.meal_ingredients << to_meal_ingredient(recipe_ingredient)
    end

    journal_day_meal.save
  end

  def journal_day_meal
    @journal_day_meal ||= @journal_day.meals.new(consumable: @recipe)
  end

  def to_meal_ingredient(recipe_ingredient)
    MealIngredient.new(
      portion: recipe_ingredient.portion,
      amount: amount_for(recipe_ingredient),
      measure: recipe_ingredient.measure
    )
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
