class Recipes::IngredientsController < ApplicationController
  before_action :set_recipe, only: %i[new create]
  before_action :set_recipe_ingredient, only: %i[edit update destroy]

  def new
    @component = Recipe::NewIngredientFormComponent.new(recipe: @recipe, params:)
  end

  def create
    @component = Recipe::NewIngredientFormComponent.new(recipe: @recipe, params:)

    if @component.recipe_ingredient_form.save
      propagate_facts_and_vegan!(@component.recipe_ingredient_form.object)
      redirect_to @recipe
    else
      render :new
    end
  end

  def edit
    form = RecipeIngredientForm.new(@recipe_ingredient)
    @component = RecipeIngredientFormComponent.new(form:)
  end

  def update
    form = RecipeIngredientForm.new(@recipe_ingredient, params)

    if form.save
      propagate_facts_and_vegan!(form.object)
      broadcast(:updated)
      flash[:turbo_notice] = 'Recipe ingredient updated'
      redirect_to form.object.recipe
    else
      @component = RecipeIngredientFormComponent.new(form:)
      render :edit
    end
  end

  def destroy
    @recipe_ingredient.destroy
    propagate_facts_and_vegan!(@recipe_ingredient)
    broadcast(:deleted)
    redirect_to @recipe_ingredient.recipe
  end

  private

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

  def broadcast(event)
    Broadcasters::RecipeIngredient.new(@recipe_ingredient, event).broadcast
  end
end
