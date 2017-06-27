class NutritionsController < ApplicationController
  before_action :set_nutrition, only: [:show, :edit, :update, :destroy]

  # GET /nutritions
  # GET /nutritions.json
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
    @nutrition.portions.new(name: '100g/ml', multiplier: 1)

    return handle_invalid_input unless @nutrition.save
    redirect_to @nutrition, notice: 'Nutrition added'
  end

  # PATCH/PUT /nutritions/1
  # PATCH/PUT /nutritions/1.json
  def update
    return handle_invalid_input unless @nutrition.save
    redirect_to @nutrition, notice: 'Nutrition updated'
  end

  # DELETE /nutritions/1
  # DELETE /nutritions/1.json
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

  def handle_invalid_input
    flash.now[:error] = 'Invalid input'
    render :new
  end
end
