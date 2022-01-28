class RecipeIngredientForm < ApplicationForm
  # include Rails.application.routes.url_helpers

  validates :portion_name, presence: true
  validates :amount_in_measure, presence: true, numericality: { greater_than: 0 }
  validates :measure, presence: true
  validate :portion_name_exists
  validate :portion_exists?

  # rubocop:disable Metrics/AbcSize
  # def initialize(object, params = {})
  #   @ingredient           = object
  #   @portion_name         = params[:portion_name] || find_portion_name_by_id(ingredient.portion&.id)
  #   @portion_id           = find_portion_id_by_name(portion_name) || ingredient.portion&.id
  #   @measure              = params[:measure] || ingredient.measure
  #   @amount_in_measure    = params[:amount_in_measure] || to_amount_in_measure(ingredient.amount)
  # end
  # rubocop:enable Metrics/AbcSize

  # def values
  #   {
  #     portion: portion,
  #     amount: amount,
  #     measure: measure
  #   }
  # end

  # def action_url
  #   if persisted?
  #     recipe_ingredient_path(recipe, ingredient)
  #   else
  #     recipe_ingredients_path(recipe)
  #   end
  # end

  def portion_name
    params[:portion_name] || find_portion_name_by_id(object.portion_id)
  end

  def portion_id
    find_portion_id_by_name(portion_name) || object.portion_id
  end

  def measure
    params[:measure] || object.measure
  end

  def amount_in_measure
    params[:amount_in_measure] || to_amount_in_measure(object.amount)
  end

  def save
    return unless valid?

    object.portion = portion
    object.amount = amount
    object.measure = measure

    super()
  end

  private

  def recipe
    @recipe ||= ingredient.recipe
  end

  def portion_exists?
    portion.present?
  end

  def portion
    @portion ||= Portion.of_user(user).find_by(id: portion_id)
  end

  def amount
    return (amount_in_measure.to_f * portion.amount) if measure_in_pieces?

    amount_in_measure
  end

  def to_amount_in_measure(amount)
    return (amount.to_f / portion.amount).round(3) if measure_in_pieces?

    amount
  end

  def measure_in_pieces?
    measure == 'piece'
  end

  def find_portion_name_by_id(id)
    PortionDecorator.portions_collection_with_id(user)
                    .find { |element| element.last == id }
                    &.first
  end

  def find_portion_id_by_name(portion_name)
    PortionDecorator.portions_collection_with_id(user)
                    .find { |element| element.first == portion_name }
                    &.last
  end

  def portion_name_exists
    errors.add(:portion_name, 'does not exist') if find_portion_id_by_name(portion_name).nil?
  end
end
