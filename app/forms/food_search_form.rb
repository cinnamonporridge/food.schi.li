class FoodSearchForm < ApplicationForm
  def food_name
    params[:food_name] || object&.name
  end

  def action_url
    params[:action_url]
  end

  def search_performed?
    food_name.present?
  end

  def food_not_found?
    search_performed? && object.new_record?
  end
end
