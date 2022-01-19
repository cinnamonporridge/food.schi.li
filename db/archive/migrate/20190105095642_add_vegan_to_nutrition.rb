class AddVeganToNutrition < ActiveRecord::Migration[5.2]
  def change
    add_column :nutritions, :vegan, :boolean, default: false, null: false
  end
end
