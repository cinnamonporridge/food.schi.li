class Foods::JournalDaysController < ApplicationController
  def index
    @food = current_user.foods.find(params[:food_id])
  end
end
