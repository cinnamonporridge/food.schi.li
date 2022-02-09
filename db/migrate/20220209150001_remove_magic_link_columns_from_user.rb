class RemoveMagicLinkColumnsFromUser < ActiveRecord::Migration[7.0]
  def change
    remove_magic_link_sent_at
    magic_link_challenge
  end

  private

  def remove_magic_link_sent_at
    remove_column :users, :magic_link_sent_at, :datetime, null: true
  end

  def magic_link_challenge
    remove_column :users, :magic_link_challenge, :string, null: true
  end
end
