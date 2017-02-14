class LoginForm
  include ActiveModel::Model

  attr_accessor :email, :password

  validates :email, presence: true
  validates :password, presence: true

  def initialize(args = {})
    @email, @password = args.values_at(:email, :password)
  end
end
