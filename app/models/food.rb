class Food < ApplicationRecord
  include Searchable
  include NutritionFacts

  belongs_to :user

  has_many :portions, dependent: :destroy
  has_one :primary_portion, -> { primary }, class_name: 'Portion', inverse_of: false, dependent: :destroy

  scope :ordered_by_name, -> { order(name: :asc) }
  scope :of_user, ->(user) { where(user:) }
  scope :of_user_or_global, ->(user) { where(user: [user, User.find_global_user]) }

  enum unit: { gram: 'gram', mililiter: 'mililiter' }

  before_save :update_data_source_update_at
  before_create :create_default_portion
  before_destroy :can_be_destroyed, prepend: true

  validates :name, presence: true, uniqueness: true
  validates :unit, presence: true

  def deleteable?
    in_recipes.none? && in_meal_ingredients.none?
  end

  def in_recipes
    @in_recipes ||= user.recipes.using_food(self)
  end

  def in_meal_ingredients
    @in_meal_ingredients ||= MealIngredient.using_food(self)
  end

  def global?
    user == User.find_global_user
  end

  private

  def can_be_destroyed
    check_if_in_recipe
    check_if_in_meal_ingredient

    throw(:abort) if errors.key?(:base)
  end

  def check_if_in_recipe
    errors.add(:base, :cannot_delete_food_still_used_in_recipe) if in_recipes.any?
  end

  def check_if_in_meal_ingredient
    errors.add(:base, :cannot_delete_food_still_used_in_meal) if in_meal_ingredients.any?
  end

  def create_default_portion
    portions.new(name: "100#{decorate.unit_abbrevation}", amount: 100)
  end

  def update_data_source_update_at
    new_value = (data_source_url_changed? && data_source_url.present?) ? Time.zone.now : nil
    self.data_source_updated_at = new_value
  end
end
