class AddMeasureToIngredients < ActiveRecord::Migration[5.1]
  def change
    add_column :ingredients, :measure, :integer, null: false, default: Ingredient.measures[:unit]
  end
end
