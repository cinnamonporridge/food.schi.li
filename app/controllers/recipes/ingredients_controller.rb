class Recipes::IngredientsController < ApplicationController
  before_action :set_recipe, only: %i[new create]
  before_action :set_recipe_ingredient, only: %i[edit update destroy]

  def new
    @component = Recipe::NewIngredientFormComponent.new(recipe: @recipe, params:)
  end

  def edit
    form = RecipeIngredientForm.new(@recipe_ingredient)
    @component = RecipeIngredientFormComponent.new(form:)
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

  def update # rubocop:disable Metrics/MethodLength
    form = RecipeIngredientForm.new(@recipe_ingredient, params)

    if form.save
      propagate_facts_and_vegan!(form.object)
      respond_to do |format|
        format.turbo_stream do
          @recipe_ingredient.reload
          render :update
        end
        format.html { redirect_to form.object.recipe }
      end
    else
      @component = RecipeIngredientFormComponent.new(form:)
      render :edit
    end
  end

  def destroy
    @recipe_ingredient.destroy
    propagate_facts_and_vegan!(@recipe_ingredient.recipe)
    redirect_to @recipe_ingredient.recipe
  end

  private

  def set_recipe
    @recipe = Recipe.of_user(current_user).active.find(params[:recipe_id])
  end

  def set_recipe_ingredient
    @recipe_ingredient = RecipeIngredient.of_user(current_user).of_active_recipes.find(params[:id])
  end

  def propagate_facts_and_vegan!(object)
    NutritionFactsService.new(object).call!
    VeganDetectionService.new(object).call!
  end
end
