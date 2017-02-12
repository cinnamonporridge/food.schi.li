class AddResetPasswordChallengeColumnsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :reset_password_link_sent_at , :datetime , null: true
    add_column :users, :reset_password_challenge    , :string   , null: true
  end
end
