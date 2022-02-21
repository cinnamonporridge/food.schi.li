class Meals::Portions::FormComponent < ViewComponent::Base
  attr_reader :form

  def initialize(form:)
    @form = form
    super()
  end

  def action_text
    @form.object.new_record? ? t('.add_portion_meal') : t('.edit_portion_meal')
  end
end
