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

  def recipes_collection
    Recipe.ordered_by_name.map do |recipe|
      [
        recipe.name,
        recipe.id
      ]
    end
  end

  def display_link_to_previous_journal_day?
    previous_journal_day.present?
  end

  def display_link_to_next_journal_day?
    next_journal_day.present?
  end

  def previous_journal_day
    journal_day_calendar_service.previous_journal_day&.decorate
  end

  def next_journal_day
    journal_day_calendar_service.next_journal_day&.decorate
  end

  # SUMS
  def sum_kcal
    model.sum_kcal.round || 0
  end

  def sum_carbs
    model.sum_carbs.round || 0
  end

  def sum_carbs_sugar_part
    model.sum_carbs_sugar_part.round || 0
  end

  def sum_protein
    model.sum_protein.round || 0
  end

  def sum_fat
    model.sum_fat.round || 0
  end

  def sum_fat_saturated
    model.sum_fat_saturated.round || 0
  end

  def sum_fiber
    model.sum_fiber.round || 0
  end

  private

  def journal_day_calendar_service
    @service ||= JournalDayCalendarService.new(model)
  end
end
