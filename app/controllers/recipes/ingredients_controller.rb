class Recipes::IngredientsController < ApplicationController
  before_action :initialize_ingredient, only: %w[new create]
  before_action :set_ingredient, only: %w[edit update destroy]

  def new
    @form = RecipeIngredientForm.new(ingredient: @ingredient)
  end

  def edit
    @form = RecipeIngredientForm.new(ingredient: @ingredient)
  end

  def create
    @form = RecipeIngredientForm.new(recipe_ingredient_params.merge(ingredient: @ingredient))

    if @form.valid? && @ingredient.update(@form.values)
      NutritionFactsService.update_all
      return handle_success('Ingredient added')
    end

    flash.now[:error] = 'Invalid input'
    render :new
  end

  def update
    @form = RecipeIngredientForm.new(recipe_ingredient_params.merge(ingredient: @ingredient))

    if @form.valid? && @ingredient.update(@form.values)
      NutritionFactsService.update(:ingredients, :recipes)
      return handle_success('Ingredient updated')
    end

    flash.now[:error] = 'Invalid input'
    render :edit
  end

  def destroy
    @ingredient.destroy
    NutritionFactsService.update(:ingredients, :recipes)
    update_recipe_vegan
    redirect_to @ingredient.recipe, notice: 'Ingredient deleted'
  end

  private

  def recipe_ingredient_params
    params.require(:recipe_ingredient).permit(:portion_name, :amount_in_measure, :measure)
  end

  def initialize_ingredient
    @ingredient = recipe.ingredients.new
  end

  def set_ingredient
    @ingredient = Ingredient.find(params[:id])
  end

  def recipe
    @recipe ||= Recipe.find(params[:recipe_id])
  end

  # def find_portion
  #   @find_portion ||= Portion.find_by(id: ingredient_params[:portion_id])
  # end

  def update_recipe_vegan
    recipe.reload
    recipe.detect_vegan
    recipe.save
  end

  def handle_success(message)
    update_recipe_vegan
    redirect_to @ingredient.recipe, notice: message
  end
end
