class PortionSelection::FoodSearchForm < ApplicationForm
  def initialize(params, user)
    @user = user
    super(Food.new, params)
  end

  def food_name
    params[:food_name] || @food&.name # use instance variable to avoid infinite loop
  end

  def action_url
    params[:action_url]
  end

  def food
    @food ||= find_food_or_new
  end

  def search_results
    @search_results ||= perform_search
  end

  def no_foods_found?
    food_name.present? && search_results.none?
  end

  def food_datalist_options
    @food_datalist_options ||= foods_scope.pluck(:name)
  end

  private

  def perform_search
    params[:food_name].blank? ? Food.none : foods_scope.search(params[:food_name])
  end

  def foods_scope
    FoodPolicy.scope_for_user(@user, :read).ordered_by_name
  end

  def find_food_or_new
    definite_food || distinct_food || foods_scope.new
  end

  def definite_food
    return foods_scope.find_by(id: food_id) if food_id.present?
  end

  def distinct_food
    return search_results.first if search_results.one?
  end

  def food_id
    params[:food_id]
  end
end
