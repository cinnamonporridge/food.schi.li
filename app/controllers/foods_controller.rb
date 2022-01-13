class FoodsController < ApplicationController
  include Pagy::Backend

  before_action :set_food, only: [:show, :edit, :update, :destroy]

  def index
    @pagy, @foods = pagy(Food.search(params[:search_query]).ordered_by_name)
  end

  def show
    @food = @food.decorate
  end

  def new
    @food = Food.new
  end

  def edit; end

  def create
    @food = Food.new(food_params)
    default_portion_name = "100#{@food.decorate.unit_abbrevation}"
    @food.portions.new(name: default_portion_name, amount: 100)

    if @food.save
      NutritionFactsService.update_all
      redirect_to @food, notice: 'Food added'
    else
      flash.now[:error] = 'Invalid input'
      render :new
    end
  end

  def update
    if @food.update(food_params)
      update_affected_recipes if @food.vegan_previously_changed?
      NutritionFactsService.update_all

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
      flash.now[:error] = 'Deletion not possible'
      @food = @food.decorate
      render :show
    end
  end

  private

  def set_food
    @food = Food.find(params[:id])
  end

  def food_params
    params.require(:food).permit(:name, :unit, :kcal, :carbs, :carbs_sugar_part, :protein, :fat, :fat_saturated,
                                 :fiber, :vegan)
  end

  def update_affected_recipes
    Recipe.using_food(@food).find_each do |recipe|
      recipe.detect_vegan
      recipe.save
    end
  end
end
