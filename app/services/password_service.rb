class PasswordService
  def self.reset!(user)
    return unless user.present?
    user.reset_password_challenge = SecureRandom.hex(32)
    # TODO send mail
    user.reset_password_link_sent_at = Time.zone.now
    user.save!
  end

  def self.magic_link!(user)
    return unless user.present?
    user.magic_link_challenge = SecureRandom.hex(256)
    # TODO send mail
    user.magic_link_sent_at = Time.zone.now
    user.save!
  end
end
