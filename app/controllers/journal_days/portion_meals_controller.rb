class JournalDays::PortionMealsController < ApplicationController
  before_action :set_journal_day, only: %i[new create]

  def new
    meal = @journal_day.meals.new
    @form = JournalDay::PortionMealForm.new(meal)
  end

  def create
    meal = @journal_day.meals.new
    @form = JournalDay::PortionMealForm.new(meal, journal_day_portion_meal_params)

    if @form.save
      NutritionFactsService.update_all
      redirect_to @journal_day, notice: 'Portion added'
    else
      flash.now[:error] = 'Invalid input'
      render :new
    end
  end

  private

  def journal_day_portion_meal_params
    params.require(:journal_day_portion_meal).permit(:portion_name, :amount_in_measure, :measure, :day_partition_id)
  end

  def set_journal_day
    @journal_day = current_user.journal_days.find(params[:journal_day_id])
  end
end
