class ResetPasswordForm
  include ActiveModel::Model

  attr_accessor :password, :challenge

  validates :password, presence: true
  validates :password, length: { minimum: 3 }

  def initialize(args = {})
    @password, @challenge = args.values_at(:password, :challenge)
  end
end
