class FoodSearchForm < ApplicationForm
  def initialize(params, user)
    @user = user
    super(Food.new, params)
  end

  def food_name
    params[:food_name]
  end

  def action_url
    params[:action_url]
  end

  def food
    @food ||= distinct_food_or_new
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
    food_name.blank? ? Food.none : foods_scope.search(food_name)
  end

  def foods_scope
    Food.of_user(@user).ordered_by_name
  end

  def distinct_food_or_new
    search_results.one? ? search_results.first : foods_scope.new
  end
end
