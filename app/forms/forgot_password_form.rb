class ForgotPasswordForm
  include ActiveModel::Model

  attr_accessor :email

  validates :email, presence: true

  def initialize(args = {})
    @email = args[:email]
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'ForgotPassword')
  end
end
