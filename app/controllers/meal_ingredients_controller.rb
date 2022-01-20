class MealIngredientsController < ApplicationController
  before_action :set_meal_ingredient, only: :destroy

  def destroy
    @meal_ingredient.destroy
    @meal_ingredient.meal.destroy if @meal_ingredient.meal.meal_ingredients.count.zero?
    redirect_to @meal_ingredient.meal.journal_day, notice: 'Meal ingredient deleted'
  end

  private

  def set_meal_ingredient
    @meal_ingredient = MealIngredient.of_user(current_user).find(params[:id])
  end
end
