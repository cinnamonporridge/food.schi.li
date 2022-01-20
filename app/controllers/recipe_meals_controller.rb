class RecipeMealsController < ApplicationController
  before_action :set_journal_day, only: %i[new create]
  before_action :set_recipe_meal, only: %i[edit update]

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

  def edit
    @form = RecipeMealForm.new(@recipe_meal)
  end

  def update
    @form = RecipeMealForm.new(@recipe_meal, recipe_meal_params)

    if @form.save
      redirect_to @recipe_meal.journal_day, notice: 'Recipe meal updated'
    else
      flash.now[:notice] = 'Invalid input'
      render :edit
    end
  end

  private

  def journal_day_recipe_meal_params
    params.require(:journal_day_recipe_meal).permit(:recipe_name, :servings, :day_partition_id)
  end

  def recipe_meal_params
    params.require(:recipe_meal).permit(:day_partition_id)
  end

  def set_journal_day
    @journal_day = JournalDay.of_user(current_user).find(params[:journal_day_id])
  end

  def set_recipe_meal
    @recipe_meal = Meal.of_recipes.of_user(current_user).find(params[:id])
  end
end
