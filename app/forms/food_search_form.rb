class FoodSearchForm < ApplicationForm
  def name
    params[:food_name] || object&.name
  end

  def action_url
    params[:action_url]
  end

  def search_performed?
    name.present? || params[:food_id].present?
  end

  def food_not_found?
    search_performed? && object.new_record?
  end
end
