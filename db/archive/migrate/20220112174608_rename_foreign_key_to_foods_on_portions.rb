class RenameForeignKeyToFoodsOnPortions < ActiveRecord::Migration[7.0]
  def change
    rename_column :portions, :nutrition_id, :food_id
  end
end
