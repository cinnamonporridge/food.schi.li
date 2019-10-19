class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true
  validates :email, length: { minimum: 7 }

  has_many :journal_days
  has_many :meals, through: :journal_days

  def requested_reset_link?
    reset_password_link_sent_at > Time.zone.now.yesterday
  end

  def quick_password=(password)
    self.password = password
    self.password_confirmation = password
    true # prevent plain text output
  end

  def clear_reset_password!
    update!(reset_password_challenge: nil, reset_password_link_sent_at: nil)
  end

  def clear_magic_link!
    update!(magic_link_challenge: nil, magic_link_sent_at: nil)
  end
end
