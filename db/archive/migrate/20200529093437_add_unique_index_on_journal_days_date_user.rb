class AddUniqueIndexOnJournalDaysDateUser < ActiveRecord::Migration[6.0]
  def change
    add_index :journal_days, [:date, :user_id], unique: true
  end
end
