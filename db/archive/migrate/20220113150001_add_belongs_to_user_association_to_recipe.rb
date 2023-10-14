class AddBelongsToUserAssociationToRecipe < ActiveRecord::Migration[7.0]
  def up
    raise "there can only be one user" if raise?

    add_reference :recipes, :user, index: true, foreign_key: true, null: true
    Recipe.update_all(user_id: find_user.id) if find_user.present? # rubocop:disable Rails/SkipsModelValidations
    change_column_null :recipes, :user_id, false
  end

  def down
    remove_reference :recipes, :user
  end

  private

  def find_user
    @find_user ||= Rails.env.production? ? User.first : User.find_by(email: "daisy@foo.bar")
  end

  def raise?
    Rails.env.production? && User.count > 1
  end
end
