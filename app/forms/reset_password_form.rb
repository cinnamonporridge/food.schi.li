class ResetPasswordForm
  include ActiveModel::Model

  attr_accessor :password

  def initialize(user)
    @user = user
  end
end
