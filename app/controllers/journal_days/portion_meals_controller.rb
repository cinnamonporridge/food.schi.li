# class JournalDays::PortionMealsController < ApplicationController
#   before_action :set_journal_day, only: %i[new create]
#   before_action :set_meal, only: %i[edit update]

#   def new
#     meal = @journal_day.meals.new
#     @form = PortionMealForm.new(meal)
#   end

#   def create
#     meal = @journal_day.meals.new
#     @form = PortionMealForm.new(meal, journal_day_portion_meal_params)

#     if @form.save
#       NutritionFactsService.update_all
#       redirect_to @journal_day, notice: 'Portion added'
#     else
#       flash.now[:error] = 'Invalid input'
#       render :new
#     end
#   end

#   def edit
#     @form = JournalDay::PortionMealForm.new(@meal)
#   end

#   private

#   def journal_day_portion_meal_params
#     params.require(:journal_day_portion_meal).permit(:portion_name, :amount_in_measure, :measure, :day_partition_id)
#   end

#   def set_journal_day
#     @journal_day = JournalDay.of_user(current_user).find(params[:journal_day_id])
#   end

#   def set_meal
#     @meal = Meal.of_user(current_user).find(params[:id])
#   end
# end
