class My::JournalDaysController < ApplicationController
  def index
    @journal_days = JournalDay.of(current_user).ordered_by_date.decorate
  end

  def show
    return handle_invalid_access unless find_journal_day.present?
    @journal_day = find_journal_day.decorate
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
      @journal_day = @journal_day.decorate
      render :new
    end
  end

  def edit
    return handle_invalid_access unless find_journal_day.present?
    @journal_day = find_journal_day.decorate
  end

  def update
    return handle_invalid_access unless find_journal_day.present?

    if find_journal_day.update(journal_day_params)
      redirect_to my_journal_day_path(find_journal_day), notice: 'Journal day updated'
    else
      flash.now[:error] = 'Invalid input'
      @journal_day = find_journal_day.decorate
      render :new
    end
  end

  def destroy
    return handle_invalid_access unless find_journal_day.present?
    find_journal_day.destroy
    redirect_to my_journal_days_path, notice: 'Journal day deleted'
  end

  private

  def journal_day_params
    params.require(:journal_day).permit(:date)
  end

  def find_journal_day
    @found_journal_day ||= current_user.journal_days.find_by(id: params[:id])
  end

  def handle_invalid_access
    flash[:warning] = 'That journal day does not exist or does not belong to you'
    redirect_to my_journal_days_path
  end
end
