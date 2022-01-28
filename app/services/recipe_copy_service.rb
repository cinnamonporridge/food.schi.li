class RecipeCopyService
  attr_reader :recipe, :name

  def initialize(recipe, name)
    @recipe = recipe
    @name = name
  end

  def copy
    Recipe.transaction do
      @recipe.dup.tap do |new_recipe|
        new_recipe.name = name
        new_recipe.recipe_ingredients = @recipe.recipe_ingredients.map(&:dup)
      end
    end
  end
end
