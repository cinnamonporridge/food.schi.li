class PortionsController < ApplicationController
  before_action :set_portion, only: [:edit, :update, :destroy]
  before_action :handle_default_portion, only: [:edit, :update, :destroy]

  def new
    @portion = find_food.portions.new
  end

  def create
    @portion = find_food.portions.new(portion_params)

    if @portion.save
      NutritionFactsService.update_all
      redirect_to @portion.food, notice: 'Portion added'
    else
      flash.now[:error] = 'Invalid input'
      render :new
    end
  end

  def edit; end

  def update
    if @portion.update(portion_params)
      NutritionFactsService.update_all
      redirect_to @portion.food, notice: 'Portion updated'
    else
      flash.now[:error] = 'Invalid input'
      render :edit
    end
  end

  def destroy
    @portion = Portion.find(params[:id])
    @portion.destroy
    redirect_to @portion.food, notice: 'Portion deleted'
  end

  private

  def portion_params
    params.require(:portion).permit(:name, :amount)
  end

  def set_portion
    @portion = Portion.find(params[:id])
  end

  def find_food
    @find_food ||= current_user.foods.find(params[:food_id])
  end

  def handle_default_portion
    redirect_to @portion.food, alert: 'Default portion cannot be edited or deleted' if @portion.primary?
  end
end
