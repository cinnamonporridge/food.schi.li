class RenameNutritionsTableToFoods < ActiveRecord::Migration[7.0]
  def change
    rename_table :nutritions, :foods
  end
end
