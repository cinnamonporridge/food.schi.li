class MealIngredientsController < ApplicationController
  before_action :set_meal_ingredient

  def edit
    @form = MealIngredientForm.new(@meal_ingredient)
  end

  def update
    @form = MealIngredientForm.new(@meal_ingredient, meal_ingredient_params)

    if @form.save
      NutritionFactsService.update_all
      redirect_to @meal_ingredient.meal.journal_day, notice: 'Meal ingredient updated'
    else
      flash[:notice] = 'Invalid input'
      render :edit
    end
  end

  private

  def set_meal_ingredient
    @meal_ingredient = MealIngredient.of_user(current_user).find(params[:id])
  end

  def meal_ingredient_params
    params.require(:meal_ingredient).permit(:amount_in_measure, :measure)
  end
end
