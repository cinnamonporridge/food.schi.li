class Recipe < ApplicationRecord
  include Archiveable
  include Searchable

  belongs_to :user

  has_many :recipe_ingredients, dependent: :destroy
  has_many :portions, through: :recipe_ingredients
  has_many :meals, as: :consumable, dependent: :restrict_with_exception

  before_validation :initialize_vegan, if: :new_record?

  validates :name, presence: true
  validates :servings, presence: true

  scope :of_user, ->(user) { where(user:) }
  scope :ordered_by_name, -> { order(name: :asc) }
  scope :using_food, ->(food) {
    includes(:portions).where(portions: { food: })
  }

  private

  def initialize_vegan
    self.vegan = true
  end
end
