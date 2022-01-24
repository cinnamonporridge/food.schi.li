class JournalDayMealFormFinderService
  def initialize(meal, params, action)
    @meal = meal
    @params = params
    @action = action
  end

  def form
    form_klass.new(meal, *permitted_params)
  end

  private

  attr_reader :meal, :params, :action

  def permitted_params
    params[:journal_day_meal]&.permit(form_klass::PERMITTED_PARAMS)
  end

  def meal_type
    meal.consumable_type.presence&.downcase || meal_type_from_params
  end

  def meal_type_from_params
    params.fetch(:meal_type)
  end

  def form_klass
    @form_klass ||= find_form_klass
  end

  def find_form_klass
    form_klass_mapping.dig(meal_type.to_sym, action.to_sym) || (raise FormClassNotFound.new(meal_type, action))
  end

  def form_klass_mapping
    {
      portion: {
        new: Meals::Portions::Form,
        edit: Meals::Portions::Form
      },
      recipe: {
        new: Meals::Recipes::NewForm,
        edit: Meals::Recipes::EditForm
      }
    }
  end

  class FormClassNotFound < StandardError
    def initialize(meal_type, action)
      super("No form class found for meal_type='#{meal_type}' action='#{action}'")
    end
  end
end
