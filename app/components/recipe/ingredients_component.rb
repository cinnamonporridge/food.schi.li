class Recipe::IngredientsComponent < ViewComponent::Base
  attr_reader :recipe

  def initialize(recipe:)
    @recipe = recipe
    super()
  end
end
