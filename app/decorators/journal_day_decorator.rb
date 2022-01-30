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

  def date_input_html
    {
      value: display_date,
      class: 'input-group-field',
      'data-date-format': 'dd.mm.yyyy'
    }
  end

  def recipes_collection
    user.recipes.active.ordered_by_name.map do |recipe|
      [
        recipe.name,
        recipe.id
      ]
    end
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
