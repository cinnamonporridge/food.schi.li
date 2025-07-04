class RecipesController < ApplicationController
  include Pagy::Backend

  before_action :set_active_recipe, only: %i[edit update]
  before_action :set_recipe_include_archived, only: %i[show destroy]

  def index
    @pagy, @recipes = pagy(user_recipes.active.search(params[:search_query]).ordered_by_name)
  end

  def show; end

  def new
    @recipe = Recipe.new
  end

  def edit; end

  def create
    @recipe = user_recipes.active.new(recipe_params)

    if @recipe.save
      redirect_to @recipe, notice: t(".success")
    else
      flash.now[:notice] = t("shared.errors.invalid_input")
      render :new
    end
  end

  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: t(".success")
    else
      flash.now[:notice] = t("shared.errors.invalid_input")
      render :edit
    end
  end

  def destroy
    if @recipe.active?
      @recipe.archive
      redirect_to recipes_url, notice: t(".archive_success")
    else
      @recipe.unarchive
      redirect_to @recipe, notice: t(".unarchive_success")
    end
  end

  private

  def set_active_recipe
    @recipe = user_recipes.active.find(params[:id])
  end

  def set_recipe_include_archived
    @recipe = user_recipes.find(params[:id])
  end

  def user_recipes
    Recipe.of_user(current_user)
  end

  def recipe_params
    params.expect(recipe: [:name, :servings, { ingredients_attributes: [:name, :quantity] }])
  end
end
