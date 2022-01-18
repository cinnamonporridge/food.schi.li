class MealIngredientsController < ApplicationController
  before_action :set_journal_day, only: %i[new create]
  before_action :set_meal_ingredient, only: %i[edit update destroy]

  def new
    return handle_invalid_journal_day_access if @journal_day.blank?

    recipe = current_user.recipes.find_by(id: params[:recipe_id])
    new_meal_ingredient = @journal_day.meal_ingredients.new(recipe:)

    @form = MealIngredientPortionForm.new(meal_ingredient: new_meal_ingredient)
  end

  def create
    return handle_invalid_journal_day_access if @journal_day.blank?

    new_meal_ingredient = @journal_day.meal_ingredients.new
    @form = MealIngredientPortionForm.new(meal_ingredient_params.merge(meal_ingredient: new_meal_ingredient))

    if @form.valid? && new_meal_ingredient.update(@form.values)
      NutritionFactsService.update_all
      return handle_success
    end

    handle_error
  end

  def edit
    return handle_invalid_meal_ingredient_access if @meal_ingredient.blank?

    @form = MealIngredientPortionForm.new(meal_ingredient: @meal_ingredient)
  end

  def update
    return handle_invalid_meal_ingredient_access if @meal_ingredient.blank?

    @form = MealIngredientPortionForm.new(meal_ingredient_params.merge(meal_ingredient: @meal_ingredient))

    if @form.valid? && @meal_ingredient.update(@form.values)
      NutritionFactsService.update_all
      redirect_to journal_day_path(@meal_ingredient.journal_day), notice: 'Meal updated'
    else
      flash.now[:error] = 'Invalid input'
      render :edit
    end
  end

  def destroy
    return handle_invalid_meal_ingredient_access if @meal_ingredient.blank?

    @meal_ingredient.destroy
    NutritionFactsService.update_all
    redirect_to journal_day_path(@meal_ingredient.journal_day), notice: 'Meal deleted'
  end

  private

  def meal_ingredient_params
    params.require(:meal_ingredient).permit(:portion_name, :amount_in_measure, :measure, :recipe_id)
  end

  def set_journal_day
    @journal_day = current_user.journal_days.find_by(id: params[:journal_day_id])
  end

  def set_meal_ingredient
    @meal_ingredient = current_user.meal_ingredients.find_by(id: params[:id])
  end

  def handle_invalid_meal_ingredient_access
    flash[:warning] = 'That meal does not exist or does not belong to you'
    redirect_to journal_days_path
  end

  def handle_invalid_journal_day_access
    flash[:warning] = 'That journal day does not exist or does not belong to you'
    redirect_to journal_days_path
  end

  def handle_success
    redirect_to journal_day_path(@journal_day), notice: 'Meal added'
  end

  def handle_error
    flash.now[:error] = 'Invalid input'
    render :new
  end
end
