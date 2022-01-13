require 'application_system_test_case'

class FoodTest < ApplicationSystemTestCase
  test 'search for nutrition' do
    sign_in_user(users(:daisy))

    navigate_to 'Foods'

    assert_selector 'h1', text: 'Foods'

    fill_in 'Search', with: 'an'
    click_on 'Search'

    assert_selector 'h1', text: 'Foods'

    assert_selector 'ul.foods li', count: 2
  end
end
