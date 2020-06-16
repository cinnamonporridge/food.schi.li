require 'application_system_test_case'

class JournalDayTest < ApplicationSystemTestCase
  test 'user adds a meal portion to journal day' do
    sign_in_user(users(:daisy))

    journal_day = journal_days(:daisy_february_first)

    visit my_journal_day_path(journal_day)

    assert_no_text 'Peanut Butter'

    click_on 'Add portion meal'

    select 'Peanut Butter (100g)', from: 'Portion'
    fill_in 'Amount in measure', with: '50'
    select 'g/ml', from: 'Measure'

    click_on 'Create Meal'

    assert_selector 'h1', text: 'Wed, 01.02.2017'
    assert_text 'Peanut Butter'
  end

  test 'user adds a recipe to journal day' do
    sign_in_user(users(:daisy))

    journal_day = journal_days(:daisy_february_first)

    visit my_journal_day_path(journal_day)

    assert_no_text 'Banana'

    click_on 'Add recipe meal'

    select 'Vegan Peanut Butter Banana (1 servings)', from: 'Recipe'
    fill_in 'Servings', with: '1'
    click_on 'Add recipe'

    assert_selector 'h1', text: 'Wed, 01.02.2017'
    assert_text 'Banana'
  end
end
