# class PortionMealsController < ApplicationController
#   before_action :set_journal_day, only: %i[new create]
#   before_action :set_portion_meal, only: %i[edit update]

#   def new
#     meal = @journal_day.meals.new
#     @form = JournalDay::PortionMealForm.new(meal)
#   end

#   def create
#     meal = @journal_day.meals.new
#     @form = JournalDay::PortionMealForm.new(meal, journal_day_portion_meal_params)

#     if @form.save
#       NutritionFactsService.update_all
#       redirect_to @journal_day, notice: 'Portion added'
#     else
#       flash.now[:notice] = 'Invalid input'
#       render :new
#     end
#   end

#   def edit
#     @form = PortionMealForm.new(@portion_meal)
#   end

#   def update
#     @form = PortionMealForm.new(@portion_meal, portion_meal_params)

#     if @form.save
#       NutritionFactsService.update_all
#       redirect_to @portion_meal.journal_day, notice: 'Portion updated'
#     else
#       flash.now[:notice] = 'Invalid input'
#       render :edit
#     end
#   end

#   private

#   # def journal_day_portion_meal_params
#   #   params.require(:journal_day_portion_meal).permit(:portion_name, :amount_in_measure, :measure, :day_partition_id)
#   # end

#   # def portion_meal_params
#   #   params.require(:portion_meal).permit(:portion_name, :amount_in_measure, :measure, :day_partition_id)
#   # end

#   def set_journal_day
#     @journal_day = JournalDay.of_user(current_user).find(params[:journal_day_id])
#   end

#   def set_portion_meal
#     @portion_meal = Meal.of_portions.of_user(current_user).find(params[:id])
#   end
# end
