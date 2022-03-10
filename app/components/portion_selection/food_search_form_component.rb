class PortionSelection::FoodSearchFormComponent < ViewComponent::Base
  attr_reader :form

  def initialize(form:)
    @form = form
    super()
  end
end
