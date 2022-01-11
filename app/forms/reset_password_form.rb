class ResetPasswordForm
  include ActiveModel::Model

  attr_accessor :password, :challenge

  validates :password, :challenge, presence: true
  validates :password, length: { minimum: 3 }
  validate :user_requested_reset_link

  def initialize(args = {})
    @password, @challenge = args.values_at(:password, :challenge)
  end

  def save
    return unless valid?

    user.password = password
    user.clear_reset_password
    user.save
  end

  def user
    @user ||= User.find_by!(reset_password_challenge: challenge)
  end

  private

  def user_requested_reset_link
    return if user.reset_password_link_sent_at.present? && user.reset_password_link_sent_at > Time.zone.now.yesterday

    errors.add(:base, :did_not_request_reset_link)
  end
end
