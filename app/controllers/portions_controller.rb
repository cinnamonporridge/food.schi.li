class PortionsController < ApplicationController
  before_action :set_portion, only: [:edit, :update, :destroy]

  def new
    @portion = find_food.portions.new
  end

  def create
    @portion = find_food.portions.new(portion_params)

    if @portion.save
      NutritionFactsService.new(user: @portion.user).update_all!
      redirect_to @portion.food, notice: 'Portion added'
    else
      flash.now[:error] = 'Invalid input'
      render :new
    end
  end

  def edit; end

  def update
    if @portion.update(portion_params)
      NutritionFactsService.new(user: @portion.user).update_all!
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
    @portion = Portion.not_primary.of_user(current_user).find(params[:id])
  end

  def find_food
    @find_food ||= Food.of_user(current_user).find(params[:food_id])
  end
end
