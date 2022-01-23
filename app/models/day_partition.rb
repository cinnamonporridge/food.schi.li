class DayPartition < ApplicationRecord
  INITIAL_POSITION = -1
  DEFAULT_POSITION = 0
  DEFAULT_NAME = 'DEFAULT'.freeze

  belongs_to :user

  after_initialize :initialize_position
  before_validation :assign_next_position, if: :initial_position?

  validates :name, :position, presence: true
  validates :name, uniqueness: { scope: :user_id }
  validates :position, numericality: { greater_than_or_equal_to: 0 }
  validate :default_day_partition_does_not_exist_yet

  scope :defaults, -> { where(position: DEFAULT_POSITION) }
  scope :not_defaults, -> { where.not(position: DEFAULT_POSITION) }
  scope :ordered_by_position, -> { order(position: :asc) }

  def default?
    position == DEFAULT_POSITION
  end

  def self.intialize_default_day_partition_for_user(user)
    find_or_initialize_by(user:, position: DEFAULT_POSITION).tap do |day_partition|
      day_partition.name = DEFAULT_NAME
    end
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

  def default_day_partition_does_not_exist_yet
    if default? && user.default_day_partition.present?
      errors.add(:base, 'Default day partition already exists')
    end
  end
end
