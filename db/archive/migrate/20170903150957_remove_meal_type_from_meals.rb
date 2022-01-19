class RemoveMealTypeFromMeals < ActiveRecord::Migration[5.1]
  def up
    remove_column :meals, :meal_type if column_exists?(:meals, :meal_type)
  end

  def down
    add_column :meals, :meal_type, :integer, null: false, default: 1
  end
end
