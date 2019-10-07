require 'application_system_test_case'

class JournalDayTest < ApplicationSystemTestCase
  test 'user adds a meal portion to journal day' do
    login_user(users(:daisy))

    journal_day = journal_days(:daisy_february_first)

    visit my_journal_day_path(journal_day)

    assert_no_text 'Peanut Butter'

    click_on 'Add portion meal'

    select 'Peanut Butter (100g)', from: 'Portion'
    fill_in 'Amount in measure', with: '50'
    select 'g/ml', from: 'Measure'

    click_on 'Create Meal'

    assert_selector 'h1', text: 'Wednesday, 01.02.2017'
    assert_text 'Peanut Butter'
  end
end
