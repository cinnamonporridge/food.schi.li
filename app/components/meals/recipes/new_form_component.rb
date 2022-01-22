class Meals::Recipes::NewFormComponent < ViewComponent::Base
  attr_reader :form

  def initialize(form:)
    @form = form
  end

  def action_text
    'Add recipe to journal day'
  end
end
