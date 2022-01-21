require 'application_system_test_case'

class JournalDay::PortionTest < ApplicationSystemTestCase
  test 'user adds a portion to journal day' do
    assert false, 'todo'
    # sign_in_user :daisy

    # journal_day = journal_days(:daisy_february_first)

    # visit journal_day_path(journal_day)

    # assert_no_text 'Peanut Butter'

    # click_on 'Add portion meal'

    # select 'Peanut Butter (100g)', from: 'Portion'
    # fill_in 'Amount in measure', with: '50'
    # select 'g/ml', from: 'Measure'

    # click_on 'Create meal'

    # assert_selector 'h1', text: 'Wed, 01.02.2017'
    # assert_text 'Peanut Butter'
  end

  test 'user edits a portion on journal day' do
    assert false, 'todo'
  end

  test 'user deletes a portion from journal day' do
    assert false, 'todo'
    # sign_in_user :daisy

    # journal_day = journal_days(:daisy_february_first)

    # visit journal_day_path(journal_day)

    # list_item = find('ul#meal-items li', text: 'Apple Big Apple')
    # list_item.click
    # list_item.click_on 'Delete'

    # assert_selector 'ul#meal-items li', text: 'Apple Big Apple', count: 0
  end
end
