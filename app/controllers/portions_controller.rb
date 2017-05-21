class PortionsController < ApplicationController
  before_action :set_portion, only: [:show, :edit, :update, :destroy]

  def index
    @portions = Portion.all
  end

  def show
  end

  def new
    @portion = Portion.new
  end

  def edit
  end

  def create
    @portion = Portion.new(portion_params)

    if @portion.save
      redirect_to @portion, notice: 'Portion was successfully created.'
    else
      render :new
    end
  end

  def update
    if @portion.update(portion_params)
      redirect_to @portion, notice: 'Portion was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @portion.destroy
    redirect_to portions_url, notice: 'Portion was successfully destroyed.'
  end

  private
  def set_portion
    @portion = Portion.find(params[:id])
  end

  def portion_params
    params.require(:portion).permit(:name, :nutrition_id, :multiplier)
  end
end
