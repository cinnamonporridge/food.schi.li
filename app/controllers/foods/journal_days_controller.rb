class Foods::JournalDaysController < ApplicationController
  def index
    @food = Food.find(params[:food_id])
  end
end
