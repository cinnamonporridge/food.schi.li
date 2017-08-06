class JournalDayDecorator < Draper::Decorator
  delegate_all

  def display_date_with_weekday
    I18n.l model.date, format: :with_weekday
  end

  def display_date
    return unless model.date.present?
    I18n.l model.date
  end

  def date_input_html
    {
      value: self.display_date,
      class: 'input-group-field',
      'data-date-format': 'dd.mm.yyyy'
    }
  end
end
