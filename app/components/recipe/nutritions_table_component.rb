class Recipe::NutritionsTableComponent < ApplicationComponent
  attr_reader :recipe

  def initialize(recipe:)
    @recipe = recipe
    super()
  end

  def to_dom_id
    dom_id(recipe, :nutritions_table)
  end
end
