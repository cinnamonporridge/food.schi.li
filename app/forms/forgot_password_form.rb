class ForgotPasswordForm
  include ActiveModel::Model

  attr_accessor :email

  validates :email, presence: true

  def initialize(args = {})
    @email = args[:email]
  end
end
