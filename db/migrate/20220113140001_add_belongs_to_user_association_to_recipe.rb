class AddBelongsToUserAssociationToRecipe < ActiveRecord::Migration[7.0]
  def up
    raise 'there can only be one user' if User.count > 1

    add_reference :recipes, :user, index: true, null: true
    Recipe.update_all(user_id: User.first.id)
    change_column_null :recipes, :user_id, false
  end

  def down
    remove_reference :recipes, :user
  end
end
