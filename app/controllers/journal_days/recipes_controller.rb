class JournalDays::RecipesController < ApplicationController
  before_action :set_journal_day

  def new
    return handle_invalid_access if @journal_day.blank?

    @form = JournalDayRecipeForm.new(@journal_day)
  end

  def create
    return handle_invalid_access if @journal_day.blank?

    @form = JournalDayRecipeForm.new(@journal_day, journal_day_recipe_params)

    if @form.valid?
      CopyRecipeToJournalDayService.new(@form.recipe, @form.servings, @journal_day).call
      NutritionFactsService.update_all
      redirect_to @journal_day, notice: 'Recipe added'
    else
      flash.now[:error] = 'Invalid input'
      render :new
    end
  end

  def destroy
    recipe_id = params[:id]
    @journal_day.meals.of_recipe(recipe_id).destroy_all
    NutritionFactsService.update_all

    redirect_to @journal_day, notice: 'Recipe removed'
  end

  private

  def journal_day_recipe_params
    params.require(:journal_day_recipe).permit(:recipe_name, :servings)
  end

  def set_journal_day
    @journal_day = current_user.journal_days.find_by(id: params[:journal_day_id])
  end

  def handle_invalid_access
    flash[:warning] = 'That journal day does not exist or does not belong to you'
    redirect_to journal_days_path
  end
end
