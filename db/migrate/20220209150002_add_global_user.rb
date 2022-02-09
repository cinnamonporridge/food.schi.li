class AddGlobalUser < ActiveRecord::Migration[7.0]
  def change
    User.find_or_create_by!(email: 'global@global.localhost') do |user|
      user.password = SecureRandom.alphanumeric(72)
    end
  end
end
