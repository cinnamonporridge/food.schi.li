class Nutritions::RecipesController < ApplicationController
  def index
    @nutrition = Nutrition.find(params[:nutrition_id])
  end
end
