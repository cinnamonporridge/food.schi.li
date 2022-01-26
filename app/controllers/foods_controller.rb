class FoodsController < ApplicationController
  include Pagy::Backend

  before_action :set_food, only: [:show, :edit, :update, :destroy]

  def index
    @pagy, @foods = pagy(current_user.foods.search(params[:search_query]).ordered_by_name)
  end

  def show
    @food = @food.decorate
  end

  def new
    @food = Food.new
  end

  def edit; end

  def create
    @food = current_user.foods.new(food_params)
    default_portion_name = "100#{@food.decorate.unit_abbrevation}"
    @food.portions.new(name: default_portion_name, amount: 100)

    if @food.save
      redirect_to @food, notice: 'Food added'
    else
      flash.now[:error] = 'Invalid input'
      render :new
    end
  end

  def update
    if @food.update(food_params)
      propagate_facts_and_vegan!
      redirect_to @food, notice: 'Food updated'
    else
      flash.now[:error] = 'Invalid input'
      render :edit
    end
  end

  def destroy
    if @food.destroy
      redirect_to foods_url, notice: 'Food deleted'
    else
      flash.now[:notice] = 'Deletion not allowed'
      @food = @food.decorate
      render :show
    end
  end

  private

  def set_food
    @food = current_user.foods.find(params[:id])
  end

  def food_params
    params.require(:food).permit(:name, :unit, :kcal, :carbs, :carbs_sugar_part, :protein, :fat, :fat_saturated,
                                 :fiber, :vegan)
  end

  def propagate_facts_and_vegan!
    NutritionFactsService.new(user: @food.user).update_all!
    VeganDetectionService.new(@food).update_all!
  end
end
