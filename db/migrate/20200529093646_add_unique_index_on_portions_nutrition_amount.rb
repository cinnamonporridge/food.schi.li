class AddUniqueIndexOnPortionsNutritionAmount < ActiveRecord::Migration[6.0]
  def change
    add_index :portions, [:nutrition_id, :amount], unique: true
  end
end
