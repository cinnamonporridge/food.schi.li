class DayPartition < ApplicationRecord
  INITIAL_POSITION = -1

  belongs_to :user

  after_initialize :initialize_position
  before_validation :assign_next_position, if: :initial_position?

  validates :name, :position, presence: true
  validates :name, uniqueness: { scope: :user_id }
  validates :position, numericality: { greater_than: 0 }
  validates :position, uniqueness: { scope: :user_id }

  scope :ordered_by_position, -> { order(position: :asc) }

  def to_label
    ["#{position} - #{name}", id]
  end

  private

  def initialize_position
    self.position ||= INITIAL_POSITION
  end

  def initial_position?
    position == INITIAL_POSITION
  end

  def assign_next_position
    return if user.blank?

    self.position = calculate_next_position
  end

  def calculate_next_position
    (user.day_partitions.maximum(:position) || 0) + 1
  end
end
