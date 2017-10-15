class JournalDayCalendarService
  def initialize(journal_day)
    @journal_day = journal_day
    @user = @journal_day.user
  end

  def next_journal_day
    @calculated_next_journal_day ||= first_journal_day_after(@journal_day.date)
  end

  def previous_journal_day
    @calculated_previous_journal_day ||= first_journal_day_before(@journal_day.date)
  end

  private

  def first_journal_day_after(date)
    user_journal_days
      .after_date(date)
      .ordered_by_date_asc
      .limit(1)
      .first
  end

  def first_journal_day_before(date)
    user_journal_days
      .before_date(date)
      .ordered_by_date_desc
      .limit(1)
      .first
  end

  def user_journal_days
    @user.journal_days
  end
end
