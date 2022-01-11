class PasswordService
  def self.reset_link!(user)
    return if user.blank?

    user.reset_password_challenge = SecureRandom.alphanumeric(10)
    PasswordMailer.reset_link_mail(user).deliver_now
    user.reset_password_link_sent_at = Time.zone.now
    user.save!
  end
end
