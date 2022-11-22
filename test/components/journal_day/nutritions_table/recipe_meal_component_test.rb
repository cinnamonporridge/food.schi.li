require 'test_helper'

class JournalDay::NutritionsTable::RecipeMealComponentTest < ViewComponent::TestCase
  test '#render' do
    render_inline new_component(meal: meals(:daisys_apple_pie_meal_on_february_fifth))

    assert_selector '.meal', text: 'Apple Pie'
    assert_selector '.meal--ingredients', text: 'Apple Big Apple'
  end
end
