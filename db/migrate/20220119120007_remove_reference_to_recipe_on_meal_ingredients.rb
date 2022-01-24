class RemoveReferenceToRecipeOnMealIngredients < ActiveRecord::Migration[7.0]
  def up
    remove_reference :meal_ingredients, :recipe
  end

  def down
    # not gonna happen
  end
end
