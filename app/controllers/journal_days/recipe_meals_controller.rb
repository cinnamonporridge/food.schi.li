class JournalDays::RecipeMealsController < ApplicationController
  before_action :set_journal_day

  def new
    meal = @journal_day.meals.new
    @form = JournalDay::RecipeMealForm.new(meal)
  end

  def create
    meal = @journal_day.meals.new
    @form = JournalDay::RecipeMealForm.new(meal, journal_day_recipe_meal_params)

    if @form.save
      NutritionFactsService.update_all
      redirect_to @journal_day, notice: 'Recipe added'
    else
      flash.now[:error] = 'Invalid input'
      render :new
    end
  end

  private

  def journal_day_recipe_meal_params
    params.require(:journal_day_recipe_meal).permit(:recipe_name, :servings, :day_partition_id)
  end

  def set_journal_day
    @journal_day = current_user.journal_days.find_by(id: params[:journal_day_id])
  end
end
