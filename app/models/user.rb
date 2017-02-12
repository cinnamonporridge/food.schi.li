class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true

  def requested_reset_link?
    self.reset_password_link_sent_at > Time.zone.now.yesterday
  end

  def quick_password=(password)
    self.password = password
    self.password_confirmation = password
    true # prevent plain text output
  end
end
