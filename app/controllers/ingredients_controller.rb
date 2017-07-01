class IngredientsController < ApplicationController
  before_action :set_ingredient, only: [:edit, :update, :destroy]
  before_action :handle_default_ingredient, only: [:edit, :update, :destroy]

  def new
    @ingredient = find_recipe.ingredients.new
  end

  def edit
  end

  def create
    @ingredient = find_recipe.ingredients.new(final_ingredient_params)

    if @ingredient.save
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

  def ingredient_params
    params.require(:ingredient).permit(:portion_id, :amount)
  end

  def final_ingredient_params
    {
      portion: find_portion,
      amount: amount_in_unit
    }
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

  def amount_in_unit
    submitted_amount = ingredient_params[:amount].to_f
    return submitted_amount if find_portion.primary?
    submitted_amount * find_portion.amount
  end

  def handle_default_ingredient
    redirect_to @ingredient.recipe, alert: 'Default ingredient cannot be edited or deleted' if @ingredient.primary?
  end
end
