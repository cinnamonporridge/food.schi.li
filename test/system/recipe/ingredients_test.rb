require 'application_system_test_case'

class Recipe::IngredientTest < ApplicationSystemTestCase
  test 'user adds an ingredient to recipe' do
    sign_in_user :daisy
    navigate_to 'Recipes'
    click_on 'Apple Pie'
    click_on 'Add ingredient'
    assert_selector 'h1', text: 'Add ingredient to Apple Pie'
    assert_link 'Cancel', href: %r{/recipes/[0-9]+}
    fill_in 'Portion name', with: 'Sugar Cube (25g)'
    fill_in 'Amount in measure', with: '3'
    select 'Pieces', from: 'Measure'
    click_on 'Add ingredient'
    assert_selector '.flash', text: 'Ingredient added'
  end

  test 'user edits an ingredient in recipe' do
    sign_in_user :daisy
    navigate_to 'Recipes'
    click_on 'Apple Pie'

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
      sign_in_user :daisy
      navigate_to 'Recipes'

      click_on 'Apple Pie'
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
end
