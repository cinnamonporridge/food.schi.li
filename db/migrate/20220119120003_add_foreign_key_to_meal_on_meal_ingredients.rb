class AddForeignKeyToMealOnMealIngredients < ActiveRecord::Migration[7.0]
  def change
    add_reference :meal_ingredients, :meal, index: true, foreign_key: true
  end
end
