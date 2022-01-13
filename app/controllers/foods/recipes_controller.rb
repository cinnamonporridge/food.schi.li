class Foods::RecipesController < ApplicationController
  def index
    @food = current_user.foods.find(params[:food_id])
  end
end
