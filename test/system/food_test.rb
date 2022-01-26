require 'application_system_test_case'

class FoodTest < ApplicationSystemTestCase
  test 'search for nutrition' do
    sign_in_and_navigate_to_foods

    assert_selector 'h1', text: 'Foods'

    fill_in 'Search', with: 'an'
    click_on 'Search'

    assert_selector 'h1', text: 'Foods'

    assert_selector 'ul.foods li', count: 2
  end

  test 'user does not see other users food' do
    sign_in_and_navigate_to_foods(:john)
    assert_text 'Apricot'
    sign_out

    sign_in_and_navigate_to_foods(:daisy)
    fill_in 'Search', with: 'Apricot'
    click_on 'Search'
    assert_no_text 'Apricot'
  end

  test 'user visits foods index page' do
    sign_in_and_navigate_to_foods

    assert_selector 'h1', text: 'Foods'
    assert_link 'Add food'
    assert_button 'Search'
  end

  test 'user visits apple food page' do
    sign_in_and_navigate_to_foods

    click_on 'Apple'

    assert_selector 'h2', text: 'Nutrition facts'
    assert_selector 'h2', text: 'Portions'

    assert_link 'Edit food'
    assert_link 'Add portion'
  end

  test 'user adds a new food' do # rubocop:disable Metrics/BlockLength
    sign_in_and_navigate_to_foods

    click_on 'Add food'
    assert_selector 'h1', text: 'New food'

    within 'form.food' do
      fill_in 'Name', with: 'White Rice'
      select 'Gram', from: 'Unit'
      check 'Vegan'
      fill_in 'Kcal', with: '129'
      fill_in 'Carbs', with: '27.9'
      fill_in 'Carbs sugar part', with: '0.05'
      fill_in 'Protein', with: '2.66'
      fill_in 'Fat', with: '0.28'
      fill_in 'Fat saturated', with: '0.076'
      fill_in 'Fiber', with: '0.4'
      click_on 'Add food'
    end

    assert_selector 'h1', text: 'White Rice'
    assert_selector '.vegan-badge'
    assert_nutrition_fact 'Kcal', '129'
    assert_nutrition_fact 'Carbs', '27.9'
    assert_nutrition_fact 'Carbs sugar part', '0.05'
    assert_nutrition_fact 'Protein', '2.66'
    assert_nutrition_fact 'Fat', '0.28'
    assert_nutrition_fact 'Fat saturated', '0.076'
    assert_nutrition_fact 'Fiber', '0.4'
    assert_selector 'ul.food--portions', text: 'Base'
  end

  test 'user adds new food, empty form' do
    sign_in_and_navigate_to_foods
    click_on 'Add food'

    within 'form.food' do
      click_on 'Add food'
    end

    assert_selector '.flash', text: 'Invalid input'
    assert_selector '.error-messages', text: "can't be blank", count: 1
    assert_selector '.error-messages', text: 'is not a number', count: 7
  end

  test 'user edits a food' do
    sign_in_and_navigate_to_foods

    click_on 'Apple'
    assert_nutrition_fact 'Kcal', '100'

    click_on 'Edit food'

    within 'form.food' do
      fill_in 'Name', with: 'Apples'
      fill_in 'Kcal', with: '72'
      check 'Vegan'
      click_on 'Update food'
    end

    assert_selector 'h1', text: 'Apples'
    assert_selector '.vegan-badge'
    assert_nutrition_fact 'Kcal', '72'
  end

  test 'user does not see button to delete a food which is used in recipe' do
    sign_in_and_navigate_to_foods
    click_on 'Milk'
    assert_no_button 'Delete food'
  end

  test 'user does not see button to delete a food which is in a meal / journal day' do
    sign_in_and_navigate_to_foods
    click_on 'Celery'
    assert_no_button 'Delete food'
  end

  test 'user can delete food that is not used in a recipe' do
    sign_in_and_navigate_to_foods
    click_on 'Sugar'
    click_on 'Delete food'
    assert_selector '.flash', text: 'Food deleted'
    assert_selector 'h1', text: 'Foods'
  end

  private

  def sign_in_and_navigate_to_foods(fixture_key = :daisy)
    sign_in_user fixture_key
    navigate_to 'Foods'
  end

  def find_nutrition_fact_row(text)
    find('.food--nutrition-fact--name', text:, exact_text: true).ancestor('li')
  end

  def assert_nutrition_fact(name, value)
    within find_nutrition_fact_row(name) do
      assert_selector '.food--nutrition-fact--value', text: value
    end
  end
end
