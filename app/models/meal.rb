class Meal < ApplicationRecord
  belongs_to :journal_day
  belongs_to :day_partition
  belongs_to :consumable, polymorphic: true

  has_many :meal_ingredients, dependent: :destroy

  # scope :of_recipes, -> { where(consumable_type: 'Recipe') }
  # scope :of_portions, -> { where(consumable_type: 'Portion') }

  before_validation :sanitize_day_partition

  scope :of_user, ->(user) { joins(journal_day: :user).where(journal_day: { user: }) }
  scope :ordered_by_consumable_type, -> { order(Arel.sql("CASE WHEN consumable_type = 'Recipe' THEN 0 ELSE 1 END ASC")) }
  scope :ordered_by_day_partition, -> { left_outer_joins(:day_partition).order("day_partitions.position ASC") }

  scope :ordered_by_consumable_type_and_day_partition, -> { ordered_by_consumable_type.ordered_by_day_partition }

  def recipe?
    consumable_type == 'Recipe'
  end

  def portion?
    consumable_type == 'Portion'
  end

  private

  def sanitize_day_partition
    self.day_partition ||= journal_day.user.default_day_partition
  end
end
