class Recipes::IngredientsController < ApplicationController
  before_action :set_recipe, only: %i[new create]
  before_action :set_recipe_ingredient, only: %i[edit update destroy]

  def new
    @form = RecipeIngredientForm.new(@recipe.recipe_ingredients.new)
  end

  def create
    @form = RecipeIngredientForm.new(@recipe.recipe_ingredients.new, recipe_ingredient_params)

    if @form.save
      propagate_facts_and_vegan!(@form.object)
      redirect_to @recipe, notice: 'Ingredient added'
    else
      flash.now[:error] = 'Invalid input'
      render :new
    end
  end

  def edit
    @form = RecipeIngredientForm.new(@recipe_ingredient)
  end

  def update
    @form = RecipeIngredientForm.new(@recipe_ingredient, recipe_ingredient_params)

    if @form.save
      propagate_facts_and_vegan!(@form.object)
      redirect_to @form.object.recipe, notice: 'Ingredient updated'
    else
      flash.now[:error] = 'Invalid input'
      render :edit
    end
  end

  def destroy
    @recipe_ingredient.destroy
    propagate_facts_and_vegan!(@recipe_ingredient)
    redirect_to @recipe_ingredient.recipe, notice: 'Ingredient deleted'
  end

  private

  def recipe_ingredient_params
    params.require(:recipe_ingredient).permit(:portion_name, :amount_in_measure, :measure)
  end

  def set_recipe
    @recipe = Recipe.of_user(current_user).active.find(params[:recipe_id])
  end

  def set_recipe_ingredient
    @recipe_ingredient = RecipeIngredient.of_user(current_user).of_active_recipes.find(params[:id])
  end

  def propagate_facts_and_vegan!(recipe_ingredient)
    NutritionFactsService.new(user: recipe_ingredient.user).update_track!(:recipes)
    VeganDetectionService.new(recipe_ingredient.recipe).update_all!
  end
end
