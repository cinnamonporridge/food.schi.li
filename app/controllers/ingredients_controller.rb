class IngredientsController < ApplicationController
  def new
    @form = RecipeIngredientForm.new(ingredient: find_recipe.ingredients.new)
  end

  def edit
    @form = RecipeIngredientForm.new(ingredient: find_ingredient)
  end

  def create
    ingredient = find_recipe.ingredients.new
    @form = RecipeIngredientForm.new(recipe_ingredient_params.merge(ingredient: ingredient))

    if @form.valid? && ingredient.update(@form.values)
      redirect_to ingredient.recipe, notice: 'Ingredient added'
    else
      flash.now[:error] = 'Invalid input'
      render :new
    end
  end

  def update
    ingredient = find_ingredient
    @form = RecipeIngredientForm.new(recipe_ingredient_params.merge(ingredient: ingredient))
    ingredient.update(@form.values)

    if @form.valid? && ingredient.update(@form.values)
      redirect_to @ingredient.recipe, notice: 'Ingredient updated'
    else
      flash.now[:error] = 'Invalid input'
      render :edit
    end
  end

  def destroy
    find_ingredient.destroy
    redirect_to @ingredient.recipe, notice: 'Ingredient deleted'
  end

  private

  def recipe_ingredient_params
    params.require(:recipe_ingredient).permit(:portion_id, :amount_in_measure, :measure)
  end

  def find_ingredient
    @ingredient ||= Ingredient.find(params[:id])
  end

  def find_recipe
    @recipe ||= Recipe.find(params[:recipe_id])
  end

  def find_portion
    @portion ||= Portion.find_by(id: ingredient_params[:portion_id])
  end
end
