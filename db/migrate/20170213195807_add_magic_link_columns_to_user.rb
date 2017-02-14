class AddMagicLinkColumnsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :magic_link_sent_at  , :datetime, null: true
    add_column :users, :magic_link_challenge, :string  , null: true
  end
end
