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
      propagate_facts_and_vegan!
      redirect_to @ingredient.recipe, notice: 'Ingredient added'
    else
      flash.now[:error] = 'Invalid input'
      render :new
    end
  end

  def update
    @form = RecipeIngredientForm.new(recipe_ingredient_params.merge(ingredient: @ingredient))

    if @form.valid? && @ingredient.update(@form.values)
      propagate_facts_and_vegan!
      redirect_to @ingredient.recipe, notice: 'Ingredient updated'
    else
      flash.now[:error] = 'Invalid input'
      render :edit
    end
  end

  def destroy
    @ingredient.destroy
    propagate_facts_and_vegan!
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

  def propagate_facts_and_vegan!
    NutritionFactsService.new(user: recipe.user).update_track!(:recipes)
    VeganDetectionService.new(recipe).update_all!
  end
end
