class FoodSearchFormComponent < ViewComponent::Base
  attr_reader :form

  def initialize(form:)
    @form = form
  end

  def food_datalist_options
    foods_scope.ordered_by_name.pluck(:name)
  end

  private

  def foods_scope
    Food.of_user(form.user)
  end
end
