class JournalDayDecorator < Draper::Decorator
  delegate_all

  def display_date
    I18n.l model.date, format: :with_weekday
  end
end
