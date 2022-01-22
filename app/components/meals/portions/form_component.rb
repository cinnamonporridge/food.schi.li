class Meals::Portions::FormComponent < ViewComponent::Base
  attr_reader :form

  def initialize(form:)
    @form = form
  end

  def action_text
    @form.object.new_record? ? 'Add portion meal' : 'Edit portion meal'
  end
end
