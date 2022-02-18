require 'application_system_test_case'

class FoodTest < ApplicationSystemTestCase
  test 'search for food' do
    sign_in_and_navigate_to_foods

    assert_selector 'h1', text: 'Foods'

    fill_in 'Search', with: 'an'
    click_on 'Search'

    assert_selector 'h1', text: 'Foods'

    assert_selector 'ul.foods li', count: 2
  end

  test 'user does not see other users food' do
    sign_in_and_navigate_to_foods(:john)
    assert_text 'Maple Syrup'
    sign_out

    sign_in_and_navigate_to_foods(:daisy)
    fill_in 'Search', with: 'Maple Syrup'
    click_on 'Search'
    assert_no_text 'Maple Syrup'
  end

  test 'user sees global food' do
    sign_in_and_navigate_to_foods(:john)
    assert_text 'Apple'
  end

  test 'user visits foods index page' do
    sign_in_and_navigate_to_foods

    assert_selector 'h1', text: 'Foods'
    assert_link 'Add food'
    assert_button 'Search'
  end

  test 'user visits own food page' do
    sign_in_and_navigate_to_foods

    click_on 'Milk'

    assert_selector 'h2', text: 'Nutrition facts'
    assert_selector 'h2', text: 'Portions'
  end

  test 'user visits global food page' do
    sign_in_and_navigate_to_foods(:john)

    click_on 'Apple'

    assert_selector 'h2', text: 'Nutrition facts'
    assert_selector 'h2', text: 'Portions'
  end

  test 'user adds a new food' do # rubocop:disable Metrics/BlockLength
    sign_in_and_navigate_to_foods

    click_on 'Add food'
    assert_selector 'h1', text: 'New food'

    within 'form.food' do
      click_on 'Add food'
    end

    assert_selector '.flash', text: 'Invalid input'
    assert_selector '.error-messages', text: "can't be blank", count: 1
    assert_selector '.error-messages', text: 'is not a number', count: 7

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

  test 'user edits own food' do
    sign_in_and_navigate_to_foods

    click_on 'Milk'
    assert_nutrition_fact 'Kcal', '120'

    click_on 'Edit food'

    within 'form.food' do
      fill_in 'Name', with: 'Soymilk'
      fill_in 'Kcal', with: '72'
      check 'Vegan'
      click_on 'Update food'
    end

    assert_selector 'h1', text: 'Soymilk'
    assert_selector '.vegan-badge'
    assert_nutrition_fact 'Kcal', '72'
  end

  test 'admin makes own food global' do
    using_browser do
      sign_in_and_navigate_to_foods
      click_on 'Milk'

      assert_selector '.global-badge', count: 0

      within '.food-header' do
        find('svg.heroicons-dots-vertical').click
        click_on 'Make food global'
        click_on 'Confirm'
      end

      assert_selector '.global-badge'
    end
  end

  test 'non-admin cannot make food global' do
    sign_in_and_navigate_to_foods(:john)
    click_on 'Maple Syrup'
    assert_no_button 'Make food global'
  end

  test 'admin edits global food' do
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

  test 'non-admin cannot edit global food' do
    sign_in_and_navigate_to_foods(:john)
    click_on 'Apple'
    assert_no_link 'Edit food'
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

  test 'user can delete own food that is not used' do
    sign_in_and_navigate_to_foods
    click_on 'Sugar'
    click_on 'Delete food'
    assert_selector '.flash', text: 'Food deleted'
    assert_selector 'h1', text: 'Foods'
  end

  test 'admin can delete global food that is not used' do
    create_global_peach!
    sign_in_and_navigate_to_foods
    click_on 'Peach'
    click_on 'Delete food'
    assert_selector '.flash', text: 'Food deleted'
    assert_selector 'h1', text: 'Foods'
  end

  test 'non-admin cannot delete global food that is not used' do
    create_global_peach!
    sign_in_and_navigate_to_foods(:john)
    click_on 'Peach'
    assert_no_button 'Delete food'
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

  def create_global_peach!
    users(:global).foods.create!(name: 'Peach', unit: 'gram',
                                 kcal: 1, carbs: 1, carbs_sugar_part: 1, protein: 1,
                                 fat: 1, fat_saturated: 1, fiber: 1)
  end
end
