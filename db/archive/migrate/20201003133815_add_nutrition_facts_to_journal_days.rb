class AddNutritionFactsToJournalDays < ActiveRecord::Migration[6.0]
  def change
    change_table :journal_days, bulk: true do |t|
      t.integer :kcal, null: false, default: 0
      t.decimal :carbs, precision: 10, scale: 3, null: false, default: 0.0
      t.decimal :carbs_sugar_part, precision: 10, scale: 3, null: false, default: 0.0
      t.decimal :protein, precision: 10, scale: 3, null: false, default: 0.0
      t.decimal :fat, precision: 10, scale: 3, null: false, default: 0.0
      t.decimal :fat_saturated, precision: 10, scale: 3, null: false, default: 0.0
      t.decimal :fiber, precision: 10, scale: 3, null: false, default: 0.0
    end
  end
end
