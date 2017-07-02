class IngredientsController < ApplicationController
  def new
    @form = RecipeIngredientForm.new(recipe: find_recipe)
  end

  def edit
  end

  def create
    @form = RecipeIngredientForm.new(recipe_ingredient_params.merge(recipe: find_recipe))
    @ingredient = find_recipe.ingredients.new(@form.values)

    if @form.valid? && @ingredient.save
      redirect_to @ingredient.recipe, notice: 'Ingredient added'
    else
      flash.now[:error] = 'Invalid input'
      render :new
    end
  end

  def update
    if @ingredient.update(final_ingredient_params)
      redirect_to @ingredient.recipe, notice: 'Ingredient updated'
    else
      flash.now[:error] = 'Invalid input'
      render :edit
    end
  end

  def destroy
    @ingredient = Ingredient.find(params[:id])
    @ingredient.destroy
    redirect_to @ingredient.recipe, notice: 'Ingredient deleted'
  end

  private

  def recipe_ingredient_params
    params.require(:recipe_ingredient).permit(:portion_id, :amount, :unit_or_pieces)
  end

  def set_ingredient
    @ingredient ||= Ingredient.find(params[:id])
  end

  def find_recipe
    @recipe ||= Recipe.find(params[:recipe_id])
  end

  def find_portion
    @portion ||= Portion.find_by(id: ingredient_params[:portion_id])
  end
end
