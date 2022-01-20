class MealsController < ApplicationController
  before_action :set_meal

  def destroy
    @meal.destroy
    NutritionFactsService.update_all
    redirect_to @meal.journal_day, notice: 'Meal deleted'
  end

  private

  def set_meal
    @meal = Meal.of_user(current_user).find(params[:id])
  end
end
