require 'application_system_test_case'

class Recipe::IngredientTest < ApplicationSystemTestCase
  test 'user adds an ingredient to recipe' do
    sign_in_and_navigate_to_apple_pie_recipe
    click_on 'Add ingredient'
    assert_selector 'h1', text: 'Add ingredient to Apple Pie'
    assert_link 'Back', href: %r{/recipes/[0-9]+}

    search_food 'Banana'

    within '.portions-select' do
      assert_checked_field 'Banana 100'
      choose 'Banana Regular'
    end

    click_on 'Add ingredient'
    assert_checked_field 'Banana Regular' # selected value should remain

    fill_in 'Amount in measure', with: '3'
    click_on 'Add ingredient'
  end

  test 'portion measure-add-on changes depending on the selected radio button' do
    using_browser do
      sign_in_and_navigate_to_apple_pie_recipe
      click_on 'Add ingredient'

      search_food 'Banana'

      assert_checked_field 'Banana 100'
      assert_selector '.portion-measure-add-on', text: 'ml/g'

      choose('Banana Regular')
      assert_selector '.portion-measure-add-on', text: 'Pieces'

      choose('Banana 100')
      assert_selector '.portion-measure-add-on', text: 'ml/g'
    end
  end

  test 'user changes food after submitting an invalid form' do
    sign_in_and_navigate_to_apple_pie_recipe
    click_on 'Add ingredient'
    search_food 'Banana'
    click_on 'Add ingredient'
    search_food 'Apple'
    assert_checked_field 'Apple 100' # checks if action_url works properly
  end

  test 'user edits an ingredient in recipe' do
    using_browser do
      sign_in_and_navigate_to_apple_pie_recipe

      within_recipe_ingredient('Apple Big Apple') do
        assert_selector '.recipe-ingredient--name', text: 'Apple Big Apple'
        assert_selector '.recipe-ingredient--quantity', text: '0.03'
        assert_selector '.recipe-ingredient--amount', text: '6'

        toggle_actions
        choose 'Apple 100'
        fill_in 'Amount in measure', with: '121'
        click_on 'Update ingredient'

        assert_selector '.recipe-ingredient--name', text: 'Apple', exact_text: true
        assert_selector '.recipe-ingredient--quantity', text: ''
        assert_selector '.recipe-ingredient--amount', text: '121'
      end

      totals_row_from_nutrition_table.tap do |row|
        assert_equal '169', row[:kcal]
        assert_equal '169', row[:carbs]
        assert_equal '169', row[:protein]
        assert_equal '169', row[:fat]
      end
    end
  end

  test 'user deletes ingredient from recipe' do
    using_browser do
      sign_in_user :daisy
      navigate_to 'Recipes'
      click_on 'PB Bread'

      totals_row_from_nutrition_table.tap do |row|
        assert_equal '96', row[:kcal]
        assert_equal '96', row[:carbs]
        assert_equal '96', row[:protein]
        assert_equal '96', row[:fat]
      end

      within_recipe_ingredient 'Whole Grain Bread Whole Grain Bread Portion' do
        toggle_actions
        click_on 'Delete recipe ingredient'
        click_on 'Confirm deletion'
      end

      totals_row_from_nutrition_table.tap do |row|
        assert_equal '89', row[:kcal]
        assert_equal '89', row[:carbs]
        assert_equal '89', row[:protein]
        assert_equal '89', row[:fat]
      end
    end
  end

  test 'user deletes last ingredient from recipe' do
    recipe_ingredients(:apples_in_apple_pie).destroy! # only "Milk" left in this recipe

    using_browser do
      sign_in_and_navigate_to_apple_pie_recipe
      within_recipe_ingredient 'Milk' do
        toggle_actions
        click_on 'Delete recipe ingredient'
        click_on 'Confirm deletion'
      end

      assert_selector 'h1', text: 'APPLE PIE'
      within '.recipe--header' do
        assert_selector '.vegan-badge'
      end
      assert_text 'No ingredients = no nutritions'
    end
  end

  test 'user deletes only non-vegan ingredient makes recipe vegan' do
    using_browser do
      sign_in_and_navigate_to_apple_pie_recipe

      within_recipe_ingredient 'Milk' do
        toggle_actions
        click_on 'Delete recipe ingredient'
        click_on 'Confirm deletion'
      end

      assert_selector 'h1', text: 'APPLE PIE'
      within '.recipe--header' do
        assert_selector '.vegan-badge'
      end

      totals_row_from_nutrition_table.tap do |row|
        assert_equal '6', row[:kcal]
        assert_equal '6', row[:carbs]
        assert_equal '6', row[:protein]
        assert_equal '6', row[:fat]
      end
    end
  end

  private

  def within_recipe_ingredient(ingredient_name, &)
    within(find('ul.recipe--ingredients li', text: ingredient_name), &)
  end

  def sign_in_and_navigate_to_apple_pie_recipe
    sign_in_user :daisy
    navigate_to 'Recipes'
    click_on 'Apple Pie'
  end

  def search_food(name)
    within '.food-search' do
      fill_in 'Search food', with: name
      click_on 'Search'
    end
  end

  def toggle_actions
    find('svg.heroicons-dots-vertical').ancestor('button').click
  end

  def totals_row_from_nutrition_table
    title, kcal, carbs, protein, fat = find_all('.nutritions-table--totals > div').to_a.map(&:text)

    { title:, kcal:, carbs:, protein:, fat: }
  end
end
