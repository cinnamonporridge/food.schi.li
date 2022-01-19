class AddMagicLinkColumnsToUser < ActiveRecord::Migration[5.0]
  def change
    change_table :users, bulk: true do |t|
      t.column :magic_link_sent_at, :datetime, null: true
      t.column :magic_link_challenge, :string, null: true
    end
  end
end
