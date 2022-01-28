class RenameIngredientsToRecipeIngredients < ActiveRecord::Migration[7.0]
  def change
    rename_table :ingredients, :recipe_ingredients
  end
end
