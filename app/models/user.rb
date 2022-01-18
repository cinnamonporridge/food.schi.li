class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true
  validates :email, length: { minimum: 7 }

  has_many :journal_days, dependent: :destroy
  has_many :foods, dependent: :destroy
  has_many :recipes, dependent: :destroy
  has_many :meal_ingredients, through: :journal_days

  def clear_reset_password
    self.reset_password_challenge = nil
    self.reset_password_link_sent_at = nil
  end

  def clear_magic_link!
    update!(magic_link_challenge: nil, magic_link_sent_at: nil)
  end

  def today
    Time.now.in_time_zone('Europe/Zurich').to_date
  end
end
