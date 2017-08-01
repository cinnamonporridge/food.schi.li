class My::JournalDaysController < ApplicationController
  def index
    @journal_days = JournalDay.of(current_user).ordered_by_date.decorate
  end

  def show
    if find_journal_day.present?
      @journal_day = find_journal_day.decorate
    else
      flash[:warning] = 'That journal day does not exist or does not belong to you'
      redirect_to my_journal_days_path
    end
  end

  def new
    @journal_day = current_user.journal_days.new(date: Time.zone.today)
  end

  def create
    @journal_day = current_user.journal_days.find_or_initialize_by(date: journal_date)
    new_journal_day = @journal_day.new_record?

    if @journal_day.save
      flash[:notice] = 'Journal day added' if new_journal_day
      redirect_to my_journal_day_path(@journal_day)
    else
      render :new
    end
  end

  def edit
    @journal_day = find_journal_day.decorate
  end

  def update
    @journal_day = find_journal_day

    if @journal_day.update(date: journal_date)
      redirect_to my_journal_day_path(@journal_day), notice: 'Journal day updated'
    else
      flash.now[:error] = 'Invalid input'
      render :new
    end
  end

  def destroy
    @journal_day = find_journal_day
    if @journal_day.present?
      @journal_day.destroy
      redirect_to my_journal_days_path, notice: 'Journal day deleted'
    else
      flash.now[:error] = 'Journal day could not be found'
      @journal_day.destroy
    end
  end

  private

  def journal_day_params
    params.require(:journal_day).permit(:date)
  end

  def find_journal_day
    @found_journal_day ||= current_user.journal_days.find_by(id: params[:id])
  end

  def journal_date
    Date.parse(date_params)
  end

  def date_params
    [
      journal_day_params['date(1i)'],
      journal_day_params['date(2i)'],
      journal_day_params['date(3i)']
    ].join('-')
  end
end
