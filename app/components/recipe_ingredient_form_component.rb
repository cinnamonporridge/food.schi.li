class RecipeIngredientFormComponent < ApplicationComponent
  attr_reader :form, :display_as_card

  delegate :recipe_ingredient, to: :form

  def initialize(form:, display_as_card: false)
    @form = form
    @display_as_card = display_as_card
    super()
  end

  def render?
    form.object.food.persisted?
  end

  def css_classes
    card_classes if display_as_card
  end

  private

  def card_classes
    "bg-white rounded overflow-hidden shadow divide-y divide-gray-200 py-2 px-4"
  end
end
