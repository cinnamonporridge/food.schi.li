class AddUniqueIndexOnNutritionsName < ActiveRecord::Migration[6.0]
  def change
    add_index :nutritions, :name, unique: true
  end
end
