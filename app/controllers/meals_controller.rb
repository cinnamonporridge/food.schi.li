class MealsController < ApplicationController
  before_action :set_journal_day, only: %i[new create]
  before_action :set_meal, only: %i[edit update destroy]

  def new
    service = JournalDayMealFormFinderService.new(@journal_day.meals.new, params, :new)
    @form = service.form
  end

  def create
    @form = JournalDayMealFormFinderService.new(@journal_day.meals.new, params, :new).form

    if @form.save
      NutritionFactsService.update_all
      redirect_to @journal_day, notice: 'Portion added'
    else
      flash.now[:notice] = 'Invalid input'
      render :new
    end
  end

  def edit
    @form = JournalDayMealFormFinderService.new(@meal, params, :edit).form
  end

  def update
    @form = JournalDayMealFormFinderService.new(@meal, params, :edit).form

    if @form.save
      NutritionFactsService.update_all
      redirect_to @meal.journal_day, notice: 'Portion updated'
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

  def find_params(form_klass)
    params.require(:journal_day_meal).permit(form_klass::PERMITTED_PARAMS)
  end

  def set_journal_day
    @journal_day = JournalDay.of_user(current_user).find(params[:journal_day_id])
  end

  def set_meal
    @meal = Meal.of_user(current_user).find(params[:id])
  end
end
