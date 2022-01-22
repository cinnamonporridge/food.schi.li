class Meals::Recipes::EditFormComponent < ViewComponent::Base
  attr_reader :form

  def initialize(form:)
    @form = form
  end

  def action_text
    'Edit recipe on journal day'
  end
end
