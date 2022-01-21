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
