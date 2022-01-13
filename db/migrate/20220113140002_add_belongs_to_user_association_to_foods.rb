class AddBelongsToUserAssociationToFoods < ActiveRecord::Migration[7.0]
  def up
    raise 'there can only be one user' if User.count > 1

    add_reference :foods, :user, index: true, null: true
    Food.update_all(user_id: User.first.id)
    change_column_null :foods, :user_id, false
  end

  def down
    remove_reference :foods, :user
  end
end
