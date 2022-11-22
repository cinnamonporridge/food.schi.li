class PortionsController < ApplicationController
  before_action :set_portion, only: [:edit, :update, :destroy]

  def new
    @portion = find_food.portions.new
  end

  def edit; end

  def create
    @portion = find_food.portions.new(portion_params)

    if @portion.save
      NutritionFactsService.new(@portion).call!
      redirect_to @portion.food, notice: t('.success')
    else
      flash.now[:notice] = t('shared.errors.invalid_input')
      render :new
    end
  end

  def update
    if @portion.update(portion_params)
      NutritionFactsService.new(@portion).call!
      redirect_to @portion.food, notice: t('.success')
    else
      flash.now[:notice] = t('shared.errors.invalid_input')
      render :edit
    end
  end

  def destroy
    @portion = Portion.find(params[:id])
    @portion.destroy
    redirect_to @portion.food, notice: t('.success')
  end

  private

  def portion_params
    params.require(:portion).permit(:name, :amount)
  end

  def set_portion
    @portion = PortionPolicy.scope_for_user(current_user, :write).not_primary.find(params[:id])
  end

  def find_food
    @find_food ||= FoodPolicy.scope_for_user(current_user, :write).find(params[:food_id])
  end
end
