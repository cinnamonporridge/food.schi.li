class My::MealsController < ApplicationController
  before_action :set_journal_day, only: %i[new create]
  before_action :set_meal, only: %i[edit update destroy]

  def new
    return handle_invalid_journal_day_access if @journal_day.blank?

    recipe = Recipe.find_by(id: params[:recipe_id])
    new_meal = @journal_day.meals.new(recipe: recipe)

    @form = MealPortionForm.new(meal: new_meal)
  end

  def create
    return handle_invalid_journal_day_access if @journal_day.blank?

    new_meal = @journal_day.meals.new
    @form = MealPortionForm.new(meal_params.merge(meal: new_meal))

    if @form.valid? && new_meal.update(@form.values)
      NutritionFactsService.update_all
      return handle_success
    end

    handle_error
  end

  def edit
    return handle_invalid_meal_access if @meal.blank?

    @form = MealPortionForm.new(meal: @meal)
  end

  def update
    return handle_invalid_meal_access if @meal.blank?

    @form = MealPortionForm.new(meal_params.merge(meal: @meal))

    if @form.valid? && @meal.update(@form.values)
      NutritionFactsService.update_all
      redirect_to my_journal_day_path(@meal.journal_day), notice: 'Meal updated'
    else
      flash.now[:error] = 'Invalid input'
      render :edit
    end
  end

  def destroy
    return handle_invalid_meal_access if @meal.blank?

    @meal.destroy
    NutritionFactsService.update_all
    redirect_to my_journal_day_path(@meal.journal_day), notice: 'Meal deleted'
  end

  private

  def meal_params
    params.require(:meal).permit(:portion_name, :amount_in_measure, :measure, :recipe_id)
  end

  def set_journal_day
    @journal_day = current_user.journal_days.find_by(id: params[:journal_day_id])
  end

  def set_meal
    @meal = current_user.meals.find_by(id: params[:id])
  end

  def handle_invalid_meal_access
    flash[:warning] = 'That meal does not exist or does not belong to you'
    redirect_to my_journal_days_path
  end

  def handle_invalid_journal_day_access
    flash[:warning] = 'That journal day does not exist or does not belong to you'
    redirect_to my_journal_days_path
  end

  def handle_success
    redirect_to my_journal_day_path(@journal_day), notice: 'Meal added'
  end

  def handle_error
    flash.now[:error] = 'Invalid input'
    render :new
  end
end
