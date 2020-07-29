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

  test 'user deletes a meal from journal day' do
    sign_in_user(users(:daisy))

    journal_day = journal_days(:daisy_february_first)

    visit my_journal_day_path(journal_day)

    list_item = find('ul#meals li', text: 'Apple Big Apple')
    list_item.click
    list_item.click_on 'Delete'

    assert_selector 'ul#meals li', text: 'Apple Big Apple', count: 0
  end

  test 'user adds and deletes a recipe from journal day' do
    sign_in_user(users(:daisy))

    journal_day = journal_days(:daisy_february_first)

    visit my_journal_day_path(journal_day)

    click_on 'Add recipe meal'

    fill_in 'Recipe', with: 'Apple Pie (6 servings)'
    click_on 'Add recipe'

    assert_selector 'h1', text: 'Wed, 01.02.2017'

    list_item = find('ul#recipes li', text: 'Apple Pie')
    list_item.click
    list_item.click_on 'Remove recipe from journal day'

    assert_selector 'h1', text: 'Wed, 01.02.2017'
    assert_selector 'ul#recipes li', text: 'Apple Pie', count: 0
  end

  test 'user adds a portion to an existing recipe on specific journal day' do
    sign_in_user(users(:daisy))

    journal_day = journal_days(:daisy_february_first)

    visit my_journal_day_path(journal_day)

    click_on 'Add recipe meal'

    fill_in 'Recipe', with: 'Apple Pie (6 servings)'
    click_on 'Add recipe'

    list_item = find('ul#recipes li', text: 'Apple Pie')
    list_item.assert_no_text 'Peanut'
    list_item.click
    list_item.click_on 'Add portion to recipe on journal day'

    assert_selector 'h1', text: 'Add portion to recipe'
    assert_text 'Add a portion to Apple Pie on 01.02.2017'

    fill_in 'Portion name', with: 'Peanut Butter (100g)'
    fill_in 'Amount in measure', with: '133'

    click_on 'Create Meal'

    list_item = find('ul#recipes li', text: 'Apple Pie')
    list_item.assert_text 'Peanut'
  end
end
