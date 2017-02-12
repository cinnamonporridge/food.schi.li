class ResetPasswordService
  def initialize(user)
    @user = user
  end

  def call
    return unless @user.present?
    @user.reset_password_challenge = SecureRandom.hex(32)
    # TODO send mail   
    @user.reset_password_link_sent_at = Time.zone.now
    @user.save!
  end

end
