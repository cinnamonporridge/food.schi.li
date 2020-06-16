require 'application_system_test_case'

class NutritionTest < ApplicationSystemTestCase
  test 'search for nutrition' do
    sign_in_user(users(:daisy))

    click_on 'Foods'

    assert_selector 'h1', text: 'Nutritions'

    fill_in 'Search', with: 'an'
    click_on 'Search'

    assert_selector 'h1', text: 'Nutritions'

    assert_selector 'ul.nutritions li', count: 2
  end
end
