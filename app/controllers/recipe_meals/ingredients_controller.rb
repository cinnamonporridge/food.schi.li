class RecipeMeals::IngredientsController < ApplicationController
  before_action :set_recipe_meal, only: %i[new create]
  before_action :set_recipe_meal_ingredient, only: %i[edit update destroy]

  def new
    @form = RecipeMeal::IngredientForm.new(@recipe_meal.meal_ingredients.new)
  end

  def create
    @form = RecipeMeal::IngredientForm.new(@recipe_meal.meal_ingredients.new, recipe_meal_ingredient_params)

    if @form.save
      NutritionFactsService.update_all
      redirect_to @recipe_meal.journal_day, notice: 'Meal ingredient added'
    else
      flash[:notice] = 'Invalid input'
      render :new
    end
  end

  def edit
    @form = RecipeMeal::IngredientForm.new(@recipe_meal_ingredient)
  end

  def update
    @form = RecipeMeal::IngredientForm.new(@recipe_meal_ingredient, recipe_meal_ingredient_params)

    if @form.save
      NutritionFactsService.update_all
      redirect_to @recipe_meal_ingredient.meal.journal_day, notice: 'Meal ingredient updated'
    else
      flash[:notice] = 'Invalid input'
      render :edit
    end
  end

  def destroy
    @recipe_meal_ingredient.destroy
    redirect_to @recipe_meal_ingredient.meal.journal_day, notice: 'Meal ingredient deleted'
  end

  private

  def recipe_meal_ingredient_params
    params.require(:recipe_meal_ingredient).permit(:portion_name, :amount_in_measure, :measure)
  end

  def set_recipe_meal
    @recipe_meal = Meal.of_recipes.of_user(current_user).find(params[:recipe_meal_id])
  end

  def set_recipe_meal_ingredient
    @recipe_meal_ingredient = MealIngredient.of_recipes.of_user(current_user).find(params[:id])
  end
end
