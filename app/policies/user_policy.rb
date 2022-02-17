class UserPolicy
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def scope
    return User.of_user_or_global(user) if user.role_admin?

    User.of_user(user)
  end
end
