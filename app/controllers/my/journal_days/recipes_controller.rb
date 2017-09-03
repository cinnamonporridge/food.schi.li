class My::JournalDays::RecipesController < ApplicationController
  before_action :set_journal_day

  def new
    @form = JournalDayRecipeForm.new(@journal_day).decorate
  end

  def create
    @form = JournalDayRecipeForm.new(@journal_day, journal_day_recipe_params)

    if @form.valid?
      CopyRecipeToJournalDayService.new(@form.recipe, @form.servings, @journal_day).call
      redirect_to [:my, @journal_day], notice: 'Recipe added'
    else
      flash.now[:error] = 'Invalid input'
      @form = @form.decorate
      render :new
    end
  end

  private

  def journal_day_recipe_params
    params.require(:journal_day_recipe).permit(:recipe_id, :servings)
  end

  def set_journal_day
    @journal_day ||= JournalDay.find_by(id: params[:journal_day_id])
  end
end
