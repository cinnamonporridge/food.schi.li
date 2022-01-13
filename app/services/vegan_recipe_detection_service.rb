class VeganRecipeDetectionService
  attr_reader :recipe

  def initialize(recipe)
    @recipe = recipe
  end

  def vegan?
    all_foods_vegan?
  end

  private

  def all_foods_vegan?
    @recipe.ingredients.all? do |ingredient|
      ingredient.food.vegan?
    end
  end
end
