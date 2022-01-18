class RenameMealsToMealIngredients < ActiveRecord::Migration[7.0]
  def change
    rename_table :meals, :meal_ingredients
  end
end
