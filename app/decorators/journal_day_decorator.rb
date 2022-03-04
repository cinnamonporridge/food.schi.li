class JournalDayDecorator < SimpleDelegator
  include NumberHelper

  def display_date_with_weekday
    I18n.l(date, format: :with_weekday)
  end

  def display_weekday
    return if date.blank?

    I18n.l(date, format: :weekday_only)
  end

  def display_date
    return if date.blank?

    I18n.l(date)
  end

  def display_kcal
    format_nutrition_number(kcal)
  end

  def display_carbs
    format_nutrition_number(carbs)
  end

  def display_protein
    format_nutrition_number(protein)
  end

  def display_fat
    format_nutrition_number(fat)
  end
end
