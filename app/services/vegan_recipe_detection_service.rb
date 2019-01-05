class VeganRecipeDetectionService
  attr_reader :recipe

  def initialize(recipe)
    @recipe = recipe
  end

  def vegan?
    all_nutritions_vegan?
  end

  private

  def all_nutritions_vegan?
    @recipe.ingredients.all? do |ingredient|
      ingredient.nutrition.vegan?
    end
  end
end
