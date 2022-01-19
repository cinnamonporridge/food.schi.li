class AddResetPasswordChallengeColumnsToUser < ActiveRecord::Migration[5.0]
  def change
    change_table :users, bulk: true do |t|
      t.column :reset_password_link_sent_at, :datetime, null: true
      t.column :reset_password_challenge, :string, null: true
    end
  end
end
