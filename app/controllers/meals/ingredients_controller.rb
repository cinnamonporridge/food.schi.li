# class Meals::IngredientsController < ApplicationController
#   before_action :set_meal_ingredient, only: %i[edit update]
#   before_action :set_recipe_meal, only: %i[new create destroy]
#   before_action :set_meal, only: %i[destroy]

#   def new
#     @form = MealIngredientForm.new(@recipe_meal.meal_ingredients.new)
#   end

#   def edit
#     @form = MealIngredientForm.new(@meal_ingredient)
#   end

#   def update
#     @form = MealIngredientForm.new(@meal_ingredient, meal_ingredient_params)

#     if @form.save
#       NutritionFactsService.update_all
#       redirect_to @meal_ingredient.meal.journal_day, notice: 'Meal ingredient updated'
#     else
#       flash[:notice] = 'Invalid input'
#       render :edit
#     end
#   end

#   private

#   def set_meal
#     @meal = Meal.of_user(current_user).find(params[:meal_id])
#   end

#   def set_recipe_meal
#     @recipe_meal = Meal.of_recipes.of_user(current_user).find(params[:meal_id])
#   end

#   def set_meal_ingredient
#     @meal_ingredient = MealIngredient.of_user(current_user).find(params[:id])
#   end

#   def meal_ingredient_params
#     params.require(:meal_ingredient).permit(:amount_in_measure, :measure)
#   end
# end
