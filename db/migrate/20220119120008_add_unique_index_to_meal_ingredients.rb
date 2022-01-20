class AddUniqueIndexToMealIngredients < ActiveRecord::Migration[7.0]
  def change
    add_index :meal_ingredients, %i[meal_id portion_id], unique: true
  end
end
