class My::JournalDaysController < ApplicationController
  before_action :find_and_decorate_journal_day, only: %i(show edit update destroy)

  def index
    @journal_days = JournalDay.of(current_user).ordered_by_date.decorate
  end

  def show
    return handle_invalid_access unless @journal_day.present?
  end

  def new
    @journal_day = current_user.journal_days.new(date: Time.zone.today)
  end

  def create
    @journal_day = current_user.journal_days.new(journal_day_params)

    if @journal_day.save
      flash[:notice] = 'Journal day added'
      redirect_to my_journal_day_path(@journal_day)
    else
      flash.now[:error] = 'Invalid input'
      render :new
    end
  end

  def edit
    return handle_invalid_access unless @journal_day.present?
  end

  def update
    return handle_invalid_access unless @journal_day.present?

    if @journal_day.update(journal_day_params)
      redirect_to my_journal_day_path(@journal_day), notice: 'Journal day updated'
    else
      flash.now[:error] = 'Invalid input'
      render :new
    end
  end

  def destroy
    return handle_invalid_access unless @journal_day.present?
    @journal_day.destroy
    redirect_to my_journal_days_path, notice: 'Journal day deleted'
  end

  private

  def journal_day_params
    params.require(:journal_day).permit(:date)
  end

  def find_and_decorate_journal_day
    @journal_day ||= current_user.journal_days.find_by(id: params[:id])&.decorate
  end

  def handle_invalid_access
    flash[:warning] = 'That journal day does not exist or does not belong to you'
    redirect_to my_journal_days_path
  end
end