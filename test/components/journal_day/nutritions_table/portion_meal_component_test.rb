require 'test_helper'

class JournalDay::NutritionsTable::PortionMealComponentTest < ViewComponent::TestCase
  test '#render' do
    render_inline new_component(meal: meals(:daisys_big_apple_meal_on_february_first))
    assert_selector '.meal', text: 'Apple Big Apple'
  end
end
