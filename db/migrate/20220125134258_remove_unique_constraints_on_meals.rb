class RemoveUniqueConstraintsOnMeals < ActiveRecord::Migration[7.0]
  def change
    remove_index :meals, %i[journal_day_id consumable_id consumable_type],
                 name: :indx_journal_day_consumable,
                 unique: true

    remove_index :meals, %i[journal_day_id day_partition_id consumable_id consumable_type],
                 name: :indx_journal_day_day_partition_consumable,
                 unique: true
  end
end
