class RemoveIsAdminFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :is_admin, :boolean, null: false, default: false
  end
end
