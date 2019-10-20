class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true
  validates :email, length: { minimum: 7 }

  has_many :journal_days, dependent: :restrict_with_exception
  has_many :meals, through: :journal_days

  def requested_reset_link?
    reset_password_link_sent_at > Time.zone.now.yesterday
  end

  def clear_reset_password!
    update!(reset_password_challenge: nil, reset_password_link_sent_at: nil)
  end

  def clear_magic_link!
    update!(magic_link_challenge: nil, magic_link_sent_at: nil)
  end
end
