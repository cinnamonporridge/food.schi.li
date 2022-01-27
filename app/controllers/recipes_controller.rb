class RecipesController < ApplicationController
  include Pagy::Backend

  before_action :set_recipe, only: [:show, :edit, :update, :destroy]

  def index
    @pagy, @recipes = pagy(current_user.recipes.active.search(params[:search_query]).ordered_by_name)
  end

  def show; end

  def new
    @recipe = Recipe.new
  end

  def edit; end

  def create
    @recipe = current_user.recipes.new(recipe_params)

    if @recipe.save
      redirect_to @recipe, notice: 'Recipe added'
    else
      flash.now[:error] = 'Invalid input'
      render :new
    end
  end

  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: 'Recipe updated'
    else
      flash.now[:error] = 'Invalid input'
      render :edit
    end
  end

  def destroy
    @recipe.archive
    redirect_to recipes_url, notice: 'Recipe archived'
  end

  private

  def set_recipe
    @recipe = current_user.recipes.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:name, :servings, ingredients_attributes: [:name, :quantity])
  end
end
