class CreateMeals < ActiveRecord::Migration[5.1]
  def change
    create_table :meals do |t|
      t.references :journal_day, foreign_key: true
      t.references :portion, foreign_key: true
      t.references :recipe, foreign_key: true
      t.decimal :amount
      t.integer :measure
      t.integer :meal_type, null: false, default: 1
      t.integer :measure_unit, null: false, default: Meal.measures[:unit]

      t.timestamps
    end
  end
end
