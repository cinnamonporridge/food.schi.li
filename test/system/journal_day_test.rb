require 'application_system_test_case'

class JournalDayTest < ApplicationSystemTestCase
  test 'user logs in' do
    sign_in_user :daisy

    assert_selector 'h1', text: 'My journal days'

    within 'nav' do
      assert_link 'Journal', href: '/journal_days'
      assert_link 'Recipes', href: '/recipes'
      assert_link 'Foods', href: '/foods'
      assert_button 'Sign out'
    end
  end

  test 'user visits a journal day' do
    sign_in_user :daisy

    click_on '01.02.2017'

    assert_selector 'h1', text: 'Wed, 01.02.2017'

    assert_selector 'h2', text: 'Nutritions'
    assert_selector '.nutritions-table'
    assert_selector 'h2', text: 'Meals'
    assert_selector '.meal-ingredients'

    assert_link 'Edit journal day'
    assert_button 'Delete journal day'
    assert_link 'Add portion meal'
    assert_link 'Add recipe meal'
  end

  test 'user adds journal day by shortcut' do
    travel_to '2022-01-03 12:00:00 UTC' do
      sign_in_user :daisy
      click_on 'Add journal day for today'
      assert_selector 'h1', text: 'Mon, 03.01.2022'
    end
  end

  test 'user does not see shortcut to create journal day if it already exists' do
    travel_to '2017-02-01 12:00:00 UTC' do
      assert_no_button 'Add journal day for today'
    end
  end

  test 'user adds journal day without shortcut' do
    sign_in_user :daisy
    click_on 'Add journal day', exact_text: true
    assert_link 'Cancel', href: '/journal_days'
    fill_in 'Date', with: '2017-02-06'
    click_on 'Add journal day'
    assert_selector 'h1', text: 'Mon, 06.02.2017'
  end

  test 'user edits journal day' do
    sign_in_user :daisy
    click_on '01.02.2017'
    click_on 'Edit journal day'
    assert_link 'Cancel', href: %r{/journal_days/[0-9]+}
    fill_in 'Date', with: '2017-01-31'
    click_on 'Edit journal day'
    assert_selector 'h1', text: 'Tue, 31.01.2017'
  end

  test 'user adds a meal portion to journal day' do
    sign_in_user :daisy

    journal_day = journal_days(:daisy_february_first)

    visit journal_day_path(journal_day)

    assert_no_text 'Peanut Butter'

    click_on 'Add portion meal'

    select 'Peanut Butter (100g)', from: 'Portion'
    fill_in 'Amount in measure', with: '50'
    select 'g/ml', from: 'Measure'

    click_on 'Create meal'

    assert_selector 'h1', text: 'Wed, 01.02.2017'
    assert_text 'Peanut Butter'
  end

  test 'user adds a recipe to journal day' do
    sign_in_user :daisy

    journal_day = journal_days(:daisy_february_first)

    visit journal_day_path(journal_day)

    assert_no_text 'Banana'

    click_on 'Add recipe meal'

    select 'Vegan Peanut Butter Banana (1 servings)', from: 'Recipe'
    fill_in 'Servings', with: '1'
    click_on 'Add recipe to journal day'

    assert_selector 'h1', text: 'Wed, 01.02.2017'
    assert_text 'Banana'
  end

  test 'user deletes a meal from journal day' do
    sign_in_user :daisy

    journal_day = journal_days(:daisy_february_first)

    visit journal_day_path(journal_day)

    list_item = find('ul#meal-items li', text: 'Apple Big Apple')
    list_item.click
    list_item.click_on 'Delete'

    assert_selector 'ul#meal-items li', text: 'Apple Big Apple', count: 0
  end

  test 'user adds and deletes a recipe from journal day' do
    sign_in_user :daisy

    journal_day = journal_days(:daisy_february_first)

    visit journal_day_path(journal_day)

    click_on 'Add recipe meal'

    fill_in 'Recipe', with: 'Apple Pie (6 servings)'
    click_on 'Add recipe to journal day'

    assert_selector 'h1', text: 'Wed, 01.02.2017'

    list_item = find('ul#recipes li', text: 'Apple Pie')
    list_item.click
    list_item.click_on 'Remove recipe'

    assert_selector 'h1', text: 'Wed, 01.02.2017'
    assert_selector 'ul#recipes li', text: 'Apple Pie', count: 0
  end

  test 'user adds a portion to an existing recipe on specific journal day' do
    sign_in_user :daisy

    journal_day = journal_days(:daisy_february_first)

    visit journal_day_path(journal_day)

    click_on 'Add recipe meal'

    fill_in 'Recipe', with: 'Apple Pie (6 servings)'
    click_on 'Add recipe to journal day'

    list_item = find('ul#recipes li', text: 'Apple Pie')
    list_item.assert_no_text 'Peanut'
    list_item.click
    list_item.click_on 'Add portion'

    assert_selector 'h1', text: 'Add portion to recipe'
    assert_text 'Add a portion to Apple Pie recipe on 01.02.2017'

    fill_in 'Portion', with: 'Peanut Butter (100g)'
    fill_in 'Amount in measure', with: '133'

    click_on 'Create meal'

    list_item = find('ul#recipes li', text: 'Apple Pie')
    list_item.assert_text 'Peanut'
  end

  test 'user toggles journal day meal actions menu' do
    using_browser do
      sign_in_user :daisy
      click_link '05.02.2017'
      within find('ul#recipes li', text: 'APPLE PIE') do
        find('svg.heroicons-chevron-down').ancestor('button').click
        assert_link 'Add portion'
        assert_button 'Remove recipe'
      end
    end
  end

  test 'user deletes a journal day' do
    sign_in_user :daisy
    click_link '01.02.2017'
    click_on 'Delete journal day'
    assert_selector '.flash', text: 'Journal day deleted'
    assert_no_link '01.02.2017'
  end
end
