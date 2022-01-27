class Recipes::CopiesController < ApplicationController
  before_action :set_recipe, only: %i[new create]

  def new
    @form = RecipeCopyForm.new(@recipe)
  end

  def create
    @form = RecipeCopyForm.new(@recipe, recipe_copy_params)

    if @form.save!
      redirect_to @form.new_recipe
    else
      render :new
    end
  end

  private

  def set_recipe
    @recipe = Recipe.active.find(params[:recipe_id])
  end

  def recipe_copy_params
    params.require(:recipe_copy).permit(:name)
  end
end
