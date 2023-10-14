class Meals::Portions::FormComponent < ViewComponent::Base
  attr_reader :form

  def initialize(form:)
    @form = form
    super()
  end

  def action_text
    @form.object.new_record? ? add_text : edit_text
  end

  private

  def add_text
    t("meals.portions.form_component.add_portion_meal")
  end

  def edit_text
    t("meals.portions.form_component.edit_portion_meal")
  end
end
