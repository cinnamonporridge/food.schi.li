class Foods::RecipesController < ApplicationController
  def index
    @food = Food.find(params[:food_id])
  end
end
