class CreateMeals < ActiveRecord::Migration[7.0]
  def change
    create_table :meals do |t|
      t.belongs_to :journal_day, index: true, foreign_key: true, null: false
      t.belongs_to :day_partition, index: true, foreign_key: true, null: false
      t.bigint :consumable_id, null: false
      t.string :consumable_type, null: false
      t.integer 'kcal', default: 0, null: false
      t.decimal 'carbs', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'carbs_sugar_part', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'protein', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'fat', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'fat_saturated', precision: 10, scale: 3, default: '0.0', null: false
      t.decimal 'fiber', precision: 10, scale: 3, default: '0.0', null: false

      t.index %i[journal_day_id consumable_id consumable_type], unique: true, name: :indx_journal_day_consumable
      t.index %i[journal_day_id day_partition_id consumable_id consumable_type], unique: true, name: :indx_journal_day_day_partition_consumable

      t.timestamps
    end
  end
end
