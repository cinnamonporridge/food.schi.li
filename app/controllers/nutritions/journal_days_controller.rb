class Nutritions::JournalDaysController < ApplicationController
  def index
    @nutrition ||= Nutrition.find(params[:nutrition_id])
  end
end
