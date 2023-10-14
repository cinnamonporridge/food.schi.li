class JournalDay < ApplicationRecord
  belongs_to :user

  has_many :meals, dependent: :destroy

  validates :date, presence: true
  validates :date, uniqueness: { scope: :user }

  scope :of_user, ->(user = User.none) { where(user:) }
  scope :ordered_by_date_asc, -> { order(date: :asc) }
  scope :ordered_by_date_desc, -> { order(date: :desc) }

  scope :after_date, ->(date) { where("date > ?", date) }
  scope :before_date, ->(date) { where("date < ?", date) }
end
