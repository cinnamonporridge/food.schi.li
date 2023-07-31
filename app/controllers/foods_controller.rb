class FoodsController < ApplicationController
  include Pagy::Backend

  before_action :set_food, only: [:show, :edit, :update, :destroy, :globalize]

  def index
    @pagy, @foods = pagy(foods_scope.search(params[:search_query]).ordered_by_name)
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

    if @food.save
      redirect_to @food, notice: t('.success')
    else
      flash.now[:notice] = t('shared.errors.invalid_input')
      render :new
    end
  end

  def update
    if @food.update(food_params)
      propagate_facts_and_vegan!
      redirect_to @food, notice: t('.success')
    else
      flash.now[:notice] = t('shared.errors.invalid_input')
      render :edit
    end
  end

  def destroy
    if @food.destroy
      redirect_to foods_url, notice: t('.success')
    else
      flash.now[:notice] = t('.deletion_not_allowed')
      @food = @food.decorate
      render :show
    end
  end

  def globalize
    authorize! @food, to: :make_global?

    @food.update(user: User.find_global_user)
    flash[:notice] = t('.success')
    redirect_to @food
  end

  private

  def set_food
    @food = foods_scope.find(params[:id])
  end

  def food_params
    params.require(:food).permit(:name, :unit,
                                 :kcal, :carbs, :carbs_sugar_part, :protein,
                                 :fat, :fat_saturated, :fiber,
                                 :vegan, :data_source_url)
  end

  def foods_scope
    scope_name = %w[index show].include?(action_name) ? :read : :write
    authorized_scope(Food.all, as: scope_name)
  end

  def propagate_facts_and_vegan!
    NutritionFactsService.new(@food).call!
    VeganDetectionService.new(@food).call!
  end
end
