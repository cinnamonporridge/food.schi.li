class ChangeColumnsToNotNullOnMealIngredients < ActiveRecord::Migration[7.0]
  def change
    change_column_null :meal_ingredients, :meal_id, false
    change_column_null :meal_ingredients, :portion_id, false
    change_column_null :meal_ingredients, :amount, false
  end
end
