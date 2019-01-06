class NutritionsController < ApplicationController
  before_action :set_nutrition, only: [:show, :edit, :update, :destroy]

  def index
    @nutritions = Nutrition.ordered_by_name
  end

  def show
    @nutrition = @nutrition.decorate
  end

  def new
    @nutrition = Nutrition.new
  end

  def edit
  end

  def create
    @nutrition = Nutrition.new(nutrition_params)
    default_portion_name = "100#{@nutrition.decorate.unit_abbrevation}"
    @nutrition.portions.new(name: default_portion_name, amount: 100)

    if @nutrition.save
      redirect_to @nutrition, notice: 'Nutrition added'
    else
      flash.now[:error] = 'Invalid input'
      render :new
    end
  end

  def update
    if @nutrition.update(nutrition_params)
      update_affected_recipes if @nutrition.vegan_previously_changed?

      redirect_to @nutrition, notice: 'Nutrition updated'
    else
      flash.now[:error] = 'Invalid input'
      render :edit
    end
  end

  def destroy
    if Recipe.using_nutrition(@nutrition).any?
      flash.now[:error] = 'Nutrition cannot be deleted, it is used in at least one recipe'
      @nutrition = @nutrition.decorate
      render :show
    else
      @nutrition.destroy
      redirect_to nutritions_url, notice: 'Nutrition deleted'
    end
  end

  private
  def set_nutrition
    @nutrition = Nutrition.find(params[:id])
  end

  def nutrition_params
    params.require(:nutrition).permit(:name, :unit, :kcal, :carbs, :carbs_sugar_part, :protein, :fat, :fat_saturated, :fiber, :vegan)
  end

  def update_affected_recipes
    Recipe.using_nutrition(@nutrition).find_each do |recipe|
      recipe.detect_vegan
      recipe.save
    end
  end
end
