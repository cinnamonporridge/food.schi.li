class RecipeIngredientForm < ApplicationForm
  include Rails.application.routes.url_helpers

  validates :portion, presence: true
  validates :amount_in_measure, presence: true, numericality: { greater_than: 0 }

  alias_method :recipe_ingredient, :object

  def portion_id
    recipe_ingredient_params[:portion_id].presence ||
      object.portion_id ||
      portions.primary.first.id
  end

  def amount_in_measure
    recipe_ingredient_params[:amount_in_measure] || to_amount_in_measure(object.amount)
  end

  delegate :food_id, to: :portion

  def save
    return unless valid?

    object.portion = portion
    object.amount = amount
    object.measure = portion.measure

    super()
  end

  # can this be private?
  def portions
    @portions ||= user_portions.where(food: object.food)
  end

  # can this be private?
  def portion
    @portion ||= user_portions.find_by(id: portion_id)
  end

  def checked_portion?(radio_portion)
    radio_portion.id == portion_id.to_i
  end

  def action_url
    if object.new_record?
      recipe_ingredients_path(object.recipe)
    else
      recipe_ingredient_path(object.recipe, object)
    end
  end

  def form_with_arguments
    {
      model: self,
      url: action_url
    }.merge(disable_turbo_if_new)
  end

  private

  def disable_turbo_if_new
    object.new_record? ? { data: { turbo: false } } : {}
  end

  def user_portions
    @user_portions ||= PortionPolicy.scope_for_user(user, :read)
  end

  def recipe_ingredient_params
    params[:recipe_ingredient]&.permit(:portion_id, :amount_in_measure, :measure) || {}
  end

  def amount
    return amount_in_measure if portion.primary?

    amount_in_measure.to_f * portion.amount
  end

  def to_amount_in_measure(amount)
    return amount if portion.primary?

    (object.amount.to_f / portion.amount).round(3)
  end
end
