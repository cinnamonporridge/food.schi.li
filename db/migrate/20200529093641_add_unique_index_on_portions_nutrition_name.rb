class AddUniqueIndexOnPortionsNutritionName < ActiveRecord::Migration[6.0]
  def change
    add_index :portions, [:nutrition_id, :name], unique: true
  end
end
