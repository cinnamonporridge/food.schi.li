class JournalDaysController < ApplicationController
  include Pagy::Backend

  before_action :set_journal_day, only: %i[show edit update destroy]

  def index
    @todays_journal_day = JournalDay.of_user(current_user).find_or_initialize_by(date: current_user.today)
    @pagy, @journal_days = pagy(JournalDay.of_user(current_user).ordered_by_date_desc)
  end

  def show; end

  def new
    @journal_day = current_user.journal_days.new(date: Time.zone.today)
  end

  def create
    @journal_day = current_user.journal_days.new(journal_day_params)

    if @journal_day.save
      flash[:notice] = 'Journal day added'
      redirect_to journal_day_path(@journal_day)
    else
      flash.now[:notice] = 'Invalid input'
      render :new
    end
  end

  def edit; end

  def update
    if @journal_day.update(journal_day_params)
      redirect_to journal_day_path(@journal_day), notice: 'Journal day updated'
    else
      flash.now[:notice] = 'Invalid input'
      render :new
    end
  end

  def destroy
    @journal_day.destroy
    redirect_to journal_days_path, notice: 'Journal day deleted'
  end

  private

  def journal_day_params
    params.require(:journal_day).permit(:date)
  end

  def set_journal_day
    @journal_day = JournalDay.of_user(current_user).find(params[:id])
  end
end
