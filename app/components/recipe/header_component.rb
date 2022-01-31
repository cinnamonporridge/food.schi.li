class Recipe::HeaderComponent < ViewComponent::Base
  attr_reader :recipe

  def initialize(recipe:)
    @recipe = recipe
  end
end
