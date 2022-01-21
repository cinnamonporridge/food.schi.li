class MealsController < ApplicationController
  before_action :set_journal_day, only: %i[new create]
  before_action :set_portion_meal, only: %i[edit update destroy]

  def new
    meal = @journal_day.meals.new
    @form = find_form.new(meal)
  end

  def create
    meal = @journal_day.meals.new
    @form = find_form.new(meal, journal_day_portion_meal_params)

    if @form.save
      NutritionFactsService.update_all
      redirect_to @journal_day, notice: 'Portion added'
    else
      flash.now[:notice] = 'Invalid input'
      render :new
    end
  end

  def edit
    @form = find_form.new(@portion_meal)
  end

  def update
    @form = find_form.new(@portion_meal, portion_meal_params)

    if @form.save
      NutritionFactsService.update_all
      redirect_to @portion_meal.journal_day, notice: 'Portion updated'
    else
      flash.now[:notice] = 'Invalid input'
      render :edit
    end
  end

  def destroy
    @meal.destroy
    NutritionFactsService.update_all
    redirect_to @meal.journal_day, notice: 'Meal deleted'
  end

  private

  def find_form
    form_mapping.dig(params[:meal_type].to_sym, action_name.to_sym)
  end

  def form_mapping
    {
      portion: {
        new: JournalDay::PortionMealForm,
        create: JournalDay::PortionMealForm,
        edit: PortionMealForm,
        update: PortionMealForm
      },
      recipe: {
        new: JournalDay::RecipeMealForm,
        create: JournalDay::RecipeMealForm,
        edit: PortionMealForm,
        update: PortionMealForm
      }
    }
  end

  def set_journal_day
    @journal_day = JournalDay.of_user(current_user).find(params[:journal_day_id])
  end

  def set_meal
    @meal = Meal.of_user(current_user).find(params[:id])
  end
end
