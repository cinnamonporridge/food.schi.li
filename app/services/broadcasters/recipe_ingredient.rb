class Broadcasters::RecipeIngredient < Broadcasters::Base
  alias_method :recipe_ingredient, :object
  delegate :recipe, to: :recipe_ingredient

  def broadcast_updated
    recipe_ingredient.reload
    update_recipe_ingredient_list_item_head
    update_recipe_nutritions_table
  end

  def broadcast_deleted
    recipe_ingredient.recipe.reload
    update_recipe
  end

  private

  def update_recipe_ingredient_list_item_head
    component = RecipeIngredient::ListItem::HeadComponent.new(recipe_ingredient: recipe_ingredient)
    broadcast_replace_to_component(channel_name, component)
  end

  def update_recipe_nutritions_table
    component = Recipe::NutritionsTableComponent.new(recipe: recipe_ingredient.recipe)
    broadcast_replace_to_component(channel_name, component)
  end

  def update_recipe
    component = Recipe::ShowComponent.new(recipe: recipe)
    broadcast_replace_to_component(channel_name, component)
  end

  def channel_name
    dom_id(recipe)
  end
end
