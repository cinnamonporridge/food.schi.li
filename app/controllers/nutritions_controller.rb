class NutritionsController < ApplicationController
  before_action :set_nutrition, only: [:show, :edit, :update, :destroy]

  def index
    @nutritions = Nutrition.ordered_by_name
  end

  def show
  end

  def new
    @nutrition = Nutrition.new
  end

  def edit
  end

  def create
    @nutrition = Nutrition.new(nutrition_params)
    @nutrition.portions.new(name: '100g/ml', amount_in_g_or_ml: 100)

    if @nutrition.save
      redirect_to @nutrition, notice: 'Nutrition added'
    else
      flash.now[:error] = 'Invalid input'
      render :new
    end
  end

  def update
    if @nutrition.update(nutrition_params)
      redirect_to @nutrition, notice: 'Nutrition updated'
    else
      flash.now[:error] = 'Invalid input'
      render :edit
    end
  end

  def destroy
    @nutrition.destroy
    respond_to do |format|
      format.html { redirect_to nutritions_url, notice: 'Nutrition was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_nutrition
    @nutrition = Nutrition.find(params[:id])
  end

  def nutrition_params
    params.require(:nutrition).permit(:name, :kcal, :carbs, :carbs_sugar_part, :protein, :fat, :fat_saturated, :fiber)
  end
end
