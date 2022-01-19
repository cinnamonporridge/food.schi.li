class CreateJournalDays < ActiveRecord::Migration[5.1]
  def change
    create_table :journal_days do |t|
      t.references :user, foreign_key: true, null: false
      t.date :date, null: false

      t.timestamps
    end
  end
end
