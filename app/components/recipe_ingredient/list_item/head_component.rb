class RecipeIngredient::ListItem::HeadComponent < ApplicationComponent
  attr_reader :recipe_ingredient

  def initialize(recipe_ingredient:)
    @recipe_ingredient = recipe_ingredient
    super()
  end

  def to_dom_id
    "#{dom_id(recipe_ingredient)}_list_item_head"
  end
end
