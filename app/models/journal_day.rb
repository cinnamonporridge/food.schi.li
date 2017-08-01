class JournalDay < ApplicationRecord
  belongs_to :user

  validates_uniqueness_of :date, scope: :user

  scope :of, -> (user = User.none) { where(user: user) }
  scope :ordered_by_date, -> { order(date: :desc) }
end
