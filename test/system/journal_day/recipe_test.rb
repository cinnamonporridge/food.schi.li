require 'application_system_test_case'

class JournalDay::RecipeTest < ApplicationSystemTestCase
  test 'user adds a recipe to journal day' do
    assert false, 'todo'
    # sign_in_user :daisy

    # journal_day = journal_days(:daisy_february_first)

    # visit journal_day_path(journal_day)

    # assert_no_text 'Banana'

    # click_on 'Add recipe meal'

    # select 'Vegan Peanut Butter Banana (1 servings)', from: 'Recipe'
    # fill_in 'Servings', with: '1'
    # click_on 'Add recipe to journal day'

    # assert_selector 'h1', text: 'Wed, 01.02.2017'
    # assert_text 'Banana'
  end

  test 'user edits recipe on journal day' do
    assert false, 'todo'
  end

  test 'user deletes a recipe from journal day' do
    assert false, 'todo'
    # sign_in_user :daisy

    # journal_day = journal_days(:daisy_february_first)

    # visit journal_day_path(journal_day)

    # click_on 'Add recipe meal'

    # fill_in 'Recipe', with: 'Apple Pie (6 servings)'
    # click_on 'Add recipe to journal day'

    # assert_selector 'h1', text: 'Wed, 01.02.2017'

    # list_item = find('ul#recipes li', text: 'Apple Pie')
    # list_item.click
    # list_item.click_on 'Remove recipe'

    # assert_selector 'h1', text: 'Wed, 01.02.2017'
    # assert_selector 'ul#recipes li', text: 'Apple Pie', count: 0
  end

  test 'user adds an ingredient to recipe on journal day' do
    assert false, 'todo'
    # sign_in_user :daisy

    # journal_day = journal_days(:daisy_february_first)

    # visit journal_day_path(journal_day)

    # click_on 'Add recipe meal'

    # fill_in 'Recipe', with: 'Apple Pie (6 servings)'
    # click_on 'Add recipe to journal day'

    # list_item = find('ul#recipes li', text: 'Apple Pie')
    # list_item.assert_no_text 'Peanut'
    # list_item.click
    # list_item.click_on 'Add portion'

    # assert_selector 'h1', text: 'Add portion to recipe'
    # assert_text 'Add a portion to Apple Pie recipe on 01.02.2017'

    # fill_in 'Portion', with: 'Peanut Butter (100g)'
    # fill_in 'Amount in measure', with: '133'

    # click_on 'Create meal'

    # list_item = find('ul#recipes li', text: 'Apple Pie')
    # list_item.assert_text 'Peanut'
  end

  test 'user edits an ingredient for a recipe on journal day' do
    assert false, 'todo'
  end

  test 'user deletes an ingredient from a recipe on journal day' do
    assert false, 'todo'
  end
end
