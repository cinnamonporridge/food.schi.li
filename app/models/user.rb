class User < ApplicationRecord
  include GlobalUser

  has_secure_password

  validates :email, presence: true
  validates :email, length: { minimum: 7 }

  before_save :create_default_day_parition, if: :new_record?

  has_many :journal_days, dependent: :destroy
  has_many :foods, dependent: :destroy
  has_many :recipes, dependent: :destroy
  has_many :meal_ingredients, through: :journal_days
  has_many :day_partitions, dependent: :destroy
  has_one :default_day_partition, -> { defaults }, class_name: 'DayPartition', inverse_of: :user, dependent: :destroy

  def clear_reset_password
    self.reset_password_challenge = nil
    self.reset_password_link_sent_at = nil
  end

  def today
    Time.now.in_time_zone('Europe/Zurich').to_date
  end

  private

  def create_default_day_parition
    day_partitions << DayPartition.intialize_default_day_partition_for_user(self)
  end
end
