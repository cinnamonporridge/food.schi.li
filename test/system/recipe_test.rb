require 'application_system_test_case'

class RecipeTest < ApplicationSystemTestCase
  test 'admin copies a recipe' do
    recipe = recipes(:peanut_butter_bread)
    sign_in_user(users(:daisy))

    visit recipe_path(recipe)

    assert_selector 'h1', text: 'PB Bread'

    click_on 'Copy'

    assert_selector 'h1', text: 'Copy PB Bread'
    assert_selector 'a', text: 'Cancel'

    click_on 'Copy recipe'

    assert_selector '[aria-invalid=true]', count: 1

    fill_in 'New recipe name', with: 'PB&J Version 1'

    click_on 'Copy recipe'

    assert_selector 'h1', text: 'PB&J Version 1'
  end

  test 'admin deletes ingredient from a recipe' do
    recipe = recipes(:peanut_butter_bread)
    sign_in_user(users(:daisy))

    visit recipe_path(recipe)

    assert_selector '.nutritions-table', text: "Per serving\n96\n"

    within('ul#ingredients-list') do
      list_item = find('li', text: 'Whole Grain Bread Whole Grain Bread Portion')
      list_item.click
      list_item.click_on 'Remove'
    end

    assert_selector 'ul#ingredients_list', text: 'Whole Grain', count: 0
    assert_selector '.nutritions-table', text: "Per serving\n89\n"
  end

  test 'deletes last ingredient from a recipe' do
    recipe = recipes(:apple_pie)
    ingredients(:milk_in_apple_pie).destroy! # we only want one recipe
    assert_equal 1, recipe.ingredients.count

    using_browser do
      sign_in_user(users(:daisy))
      navigate_to 'Recipes'

      click_on 'Apple Pie'
      assert_selector '.nutritions-table'

      within find('ul#ingredients-list li', text: 'Apple') do
        click_on 'Apple'
        click_on 'Remove ingredient'
      end

      assert_text 'No ingredients = no nutritions.'
    end
  end
end
