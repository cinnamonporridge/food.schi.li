class JournalDays::MealsController < ApplicationController
  before_action :set_journal_day, only: %i[new create]
  before_action :set_meal, only: %i[edit update destroy]

  def new
    meal = @journal_day.meals.new
    @form = NewPortionMealForm.new(meal)
  end

  def create
    meal = @journal_day.meals.new
    @form = NewPortionMealForm.new(meal, journal_day_meal_params)

    if @form.save
      NutritionFactsService.update_all
      redirect_to @journal_day, notice: 'Portion meal added'
    else
      render :new
    end
  end

  # def edit
  #   return handle_invalid_meal_ingredient_access if @meal_ingredient.blank?

  #   @form = MealIngredientPortionForm.new(meal_ingredient: @meal_ingredient)
  # end

  # def update
  #   return handle_invalid_meal_ingredient_access if @meal_ingredient.blank?

  #   @form = MealIngredientPortionForm.new(meal_ingredient_params.merge(meal_ingredient: @meal_ingredient))

  #   if @form.valid? && @meal_ingredient.update(@form.values)
  #     NutritionFactsService.update_all
  #     redirect_to journal_day_path(@meal_ingredient.journal_day), notice: 'Meal updated'
  #   else
  #     flash.now[:error] = 'Invalid input'
  #     render :edit
  #   end
  # end

  def destroy
    return handle_invalid_meal_ingredient_access if @meal_ingredient.blank?

    @meal_ingredient.destroy
    NutritionFactsService.update_all
    redirect_to journal_day_path(@meal_ingredient.journal_day), notice: 'Meal deleted'
  end

  private

  def journal_day_meal_params
    params.require(:journal_day_meal).permit(:portion_name, :amount_in_measure, :measure, :day_partition_id)
  end

  def set_journal_day
    @journal_day = current_user.journal_days.find(params[:journal_day_id])
  end

  def set_meal
    @meal = @journal_day.meals.find(params[:id])
  end
end
