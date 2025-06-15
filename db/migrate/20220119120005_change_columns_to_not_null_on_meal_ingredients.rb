class ChangeColumnsToNotNullOnMealIngredients < ActiveRecord::Migration[7.0]
  def up
    change_table :meal_ingredients, bulk: true do |t|
      t.change :meal_id, :bigint, null: false
      t.change :portion_id, :bigint, null: false
      t.change :amount, :decimal, null: false
    end
  end

  def down
    # not intended
  end
end
