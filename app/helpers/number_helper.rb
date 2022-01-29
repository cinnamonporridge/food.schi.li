module NumberHelper
  include ActionView::Helpers::NumberHelper

  def format_nutrition_number(number)
    number_with_delimiter(number.round, delimiter: "'")
  end
end
