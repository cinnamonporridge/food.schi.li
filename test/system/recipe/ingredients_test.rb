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
    assert_selector '.flash', text: 'Ingredient added'
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
    sign_in_and_navigate_to_apple_pie_recipe

    within_recipe_ingredient('Apple Big Apple') do
      click_on 'Edit ingredient'
    end

    assert_selector 'h1', text: 'Edit ingredient for Apple Pie'
    assert_link 'Cancel', href: %r{/recipes/[0-9]+}
    fill_in 'Amount in measure', with: '2'
    click_on 'Update ingredient'

    assert_selector '.flash', text: 'Ingredient updated'

    within_recipe_ingredient('Apple Big Apple') do
      assert_text '400' # grams
    end
  end

  test 'user deletes ingredient from recipe' do
    sign_in_user :daisy
    navigate_to 'Recipes'
    click_on 'PB Bread'

    assert_selector '.nutritions-table', text: "Per serving (1/1)\n96\n"

    within_recipe_ingredient 'Whole Grain Bread Whole Grain Bread Portion' do
      click_on 'Remove'
    end

    assert_selector 'ul.recipe--ingredients', text: 'Whole Grain', count: 0
    assert_selector '.nutritions-table', text: "Per serving (1/1)\n89\n"
  end

  test 'user deletes last ingredient from recipe' do
    recipe = recipes(:apple_pie)
    recipe_ingredients(:milk_in_apple_pie).destroy! # we only want one recipe ingredient
    assert_equal 1, recipe.recipe_ingredients.count

    using_browser do
      sign_in_and_navigate_to_apple_pie_recipe
      assert_selector '.nutritions-table'

      within_recipe_ingredient 'Apple' do
        find('svg.heroicons-dots-vertical').ancestor('button').click
        click_on 'Remove ingredient'
      end

      assert_text 'No ingredients = no nutritions.'
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
end
