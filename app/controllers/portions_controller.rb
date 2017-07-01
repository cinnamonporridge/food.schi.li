class PortionsController < ApplicationController
  before_action :set_portion, only: [:edit, :update, :destroy]
  before_action :handle_default_portion, only: [:edit, :update, :destroy]

  def new
    @portion = find_nutrition.portions.new
  end

  def edit
  end

  def create
    @portion = find_nutrition.portions.new(portion_params)

    if @portion.save
      redirect_to @portion.nutrition, notice: 'Portion added'
    else
      flash.now[:error] = 'Invalid input'
      render :new
    end
  end

  def update
    if @portion.update(portion_params)
      redirect_to @portion.nutrition, notice: 'Portion updated'
    else
      flash.now[:error] = 'Invalid input'
      render :edit
    end
  end

  def destroy
    @portion = Portion.find(params[:id])
    @portion.destroy
    redirect_to @portion.nutrition, notice: 'Portion deleted'
  end

  private

  def portion_params
    params.require(:portion).permit(:name, :amount)
  end

  def set_portion
    @portion ||= Portion.find(params[:id])
  end

  def find_nutrition
    @nutrition ||= Nutrition.find(params[:nutrition_id])
  end

  def handle_default_portion
    redirect_to @portion.nutrition, alert: 'Default portion cannot be edited or deleted' if @portion.primary?
  end
end
