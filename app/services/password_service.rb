class PasswordService
  def self.reset_link!(user)
    return unless user.present?
    user.reset_password_challenge = SecureRandom.hex(32)
    PasswordMailer.reset_link_mail(user).deliver_now
    user.reset_password_link_sent_at = Time.zone.now
    user.save!
  end

  def self.magic_link!(user)
    return unless user.present?
    user.magic_link_challenge = SecureRandom.hex(64)
    PasswordMailer.magic_link_mail(user).deliver_now
    user.magic_link_sent_at = Time.zone.now
    user.save!
  end
end
