class AddVeganToJournalDay < ActiveRecord::Migration[7.0]
  def change
    add_column :journal_days, :vegan, :boolean, default: false, null: false
  end
end
