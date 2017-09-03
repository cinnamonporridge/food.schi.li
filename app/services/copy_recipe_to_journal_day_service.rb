class CopyRecipeToJournalDayService
  def initialize(recipe, number_of_servings, journal_day)
    @recipe = recipe
    @number_of_servings = number_of_servings
    @journal_day = journal_day
  end

  def call
    @recipe.ingredients.each do |recipe_ingredient|
      copy_ingredient_to_journal_day(recipe_ingredient)
    end
  end

  private

  def copy_ingredient_to_journal_day(recipe_ingredient)
    new_meal = @journal_day.meals.new(
      portion: recipe_ingredient.portion,
      recipe: @recipe,
      amount: amount_for(recipe_ingredient),
      measure: recipe_ingredient.measure
    )

    new_meal.save
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
