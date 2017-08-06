class My::MealsController < ApplicationController
  before_action :set_journal_day, only: %i(new create)
  before_action :set_meal, only: %i(edit update destroy)

  def new
    return handle_invalid_meal_type unless Meal.meal_types.keys.include?(params[:meal_type])
    return handle_invalid_journal_day_access unless @journal_day.present?

    new_meal = @journal_day.meals.new(meal_type: params[:meal_type])

    if new_meal.meal_type_portion?
      @form = MealPortionForm.new(meal: new_meal)
    elsif new_meal.meal_type_recipe?
      # TODO
    else
      # TODO
    end
  end

  def create
    return handle_invalid_meal_type unless Meal.meal_types.keys.include?(meal_params[:meal_type])
    return handle_invalid_journal_day_access unless @journal_day.present?

    new_meal = @journal_day.meals.new(meal_type: meal_params[:meal_type])

    if new_meal.meal_type_portion?
      @form = MealPortionForm.new(meal_params.merge(meal: new_meal))
    elsif new_meal.meal_type_recipe?
      # TODO
    else
      # TODO
    end

    if @form.valid? && new_meal.update(@form.values)
      redirect_to my_journal_day_path(new_meal.journal_day), notice: 'Meal added'
    else
      flash.now[:error] = 'Invalid input'
      render :new
    end
  end

  def edit
    return handle_invalid_meal_access unless @meal.present?

    if @meal.meal_type_portion?
      @form = MealPortionForm.new(meal: @meal)
    elsif new_meal.meal_type_recipe?
      # TODO
    else
      # TODO
    end
  end

  def update
    return handle_invalid_meal_access unless @meal.present?

    if @meal.meal_type_portion?
      @form = MealPortionForm.new(meal_params.merge(meal: @meal))
    elsif new_meal.meal_type_recipe?
      # TODO
    else
      # TODO
    end

    if @form.valid? && @meal.update(@form.values)
      redirect_to my_journal_day_path(@meal.journal_day), notice: 'Meal updated'
    else
      flash.now[:error] = 'Invalid input'
      render :edit
    end
  end

  def destroy
    return handle_invalid_meal_access unless @meal.present?
    @meal.destroy
    redirect_to my_journal_day_path(@meal.journal_day), notice: 'Meal deleted'
  end

  private

  def meal_params
    params.require(:meal).permit(:portion_id, :amount_in_measure, :measure, :meal_type)
  end

  def set_journal_day
    @journal_day = current_user.journal_days.find_by(id: params[:journal_day_id])
  end

  def set_meal
    @meal = current_user.meals.find_by(id: params[:id])
  end

  def handle_invalid_meal_type
    flash[:warning] = 'Invalid meal type'
    redirect_to my_journal_day_path(@journal_day)
  end

  def handle_invalid_meal_access
    flash[:warning] = 'That meal does not exist or does not belong to you'
    redirect_to my_journal_days_path
  end

  def handle_invalid_journal_day_access
    flash[:warning] = 'That journal day does not exist or does not belong to you'
    redirect_to my_journal_days_path
  end
end
