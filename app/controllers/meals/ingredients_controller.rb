class Meals::IngredientsController < ApplicationController
  before_action :set_meal, only: %i[new create]
  before_action :set_meal_ingredient, only: %i[edit update destroy]

  def new
    @form = MealIngredientForm.new(@meal.meal_ingredients.new)
  end

  def edit
    @form = MealIngredientForm.new(@meal_ingredient)
  end

  def create
    @form = MealIngredientForm.new(@meal.meal_ingredients.new, meal_ingredient_params)

    if @form.save
      NutritionFactsService.new(@form.object).call!
      redirect_to @meal.journal_day, notice: t('.success')
    else
      flash.now[:notice] = t('shared.errors.invalid_input')
      render :new
    end
  end

  def update
    @form = MealIngredientForm.new(@meal_ingredient, meal_ingredient_params)

    if @form.save
      NutritionFactsService.new(@form.object).call!
      redirect_to @meal_ingredient.meal.journal_day, notice: t('.success')
    else
      flash.now[:notice] = t('shared.errors.invalid_input')
      render :edit
    end
  end

  def destroy
    @meal_ingredient.destroy
    NutritionFactsService.new(@meal_ingredient.meal).call!
    redirect_to @meal_ingredient.meal.journal_day, notice: t('.success')
  end

  private

  def meal_ingredient_params
    params.require(:meal_ingredient).permit(:portion_name, :amount_in_measure, :measure)
  end

  def set_meal
    @meal = Meal.of_recipes.of_user(current_user).find(params[:meal_id])
  end

  def set_meal_ingredient
    @meal_ingredient = MealIngredient.of_recipes.of_user(current_user).find(params[:id])
  end
end
