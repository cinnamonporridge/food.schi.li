require 'application_system_test_case'

class JournalDay::RecipeTest < ApplicationSystemTestCase
  test 'user adds a recipe to journal day' do
    sign_in_user :daisy
    click_on '01.02.2017'

    click_on 'Add recipe meal'
    fill_in 'Recipe name', with: 'Vegan Peanut Butter Banana (1 servings)'
    fill_in 'Servings', with: '2'
    select 'Afternoon', from: 'Day partition'
    click_on 'Add recipe to journal day'

    within_recipe_meal 'Vegan Peanut Butter Banana' do
      assert_text 'Afternoon'
      assert_selector 'ul.recipe-meal--ingredients li', text: 'Banana Regular'
      assert_selector 'ul.recipe-meal--ingredients li', text: 'Peanut Butter'
    end
  end

  test 'user edits recipe meal on journal day' do
    assert_not_equal day_partitions(:daisy_afternoon), meals(:daisys_apple_pie_meal_on_february_fifth).day_partition

    sign_in_user :daisy
    click_on '05.02.2017'

    within_recipe_meal 'Apple Pie' do
      click_on 'Edit meal'
    end

    select 'Lunch', from: 'Day partition'
    click_on 'Edit recipe on journal day'

    within_recipe_meal 'Apple Pie' do
      assert_text 'Lunch'
    end
  end

  test 'user deletes a meal' do
    sign_in_user :daisy
    click_on '05.02.2017'

    within_recipe_meal 'Apple Pie' do
      click_on 'Remove meal'
    end

    assert_selector '.flash', text: 'Meal deleted'
    assert_selector 'li.recipe-meal', text: 'Apple Pie', count: 0
  end

  test 'user adds an ingredient to recipe on journal day' do
    sign_in_user :daisy
    click_on '05.02.2017'

    within_recipe_meal 'Apple Pie' do
      click_on 'Add meal ingredient'
    end

    fill_in 'Portion', with: 'Sugar Cube (25g)'
    fill_in 'Amount in measure', with: '3'
    select 'Pieces', from: 'Measure'
    click_on 'Add meal ingredient'

    within_recipe_meal 'Apple Pie' do
      assert_text 'Sugar Cube'
    end
  end

  test 'user edits an ingredient for a recipe on journal day' do
    sign_in_user :daisy
    click_on '05.02.2017'

    within_recipe_meal_ingredient 'Apple Pie', 'Apple Big Apple' do
      assert_selector '.recipe-meal--ingredient--quantity', text: '0.03'
      assert_selector '.recipe-meal--ingredient--amount', text: '6'
      click_on 'Edit meal ingredient'
    end

    fill_in 'Amount in measure', with: '2'
    click_on 'Update meal ingredient'

    within_recipe_meal_ingredient 'Apple Pie', 'Apple Big Apple' do
      assert_selector '.recipe-meal--ingredient--quantity', text: '2.0'
      assert_selector '.recipe-meal--ingredient--amount', text: '400'
    end
  end

  test 'user deletes an ingredient from a recipe on journal day' do
    sign_in_user :daisy
    click_on '05.02.2017'

    within_recipe_meal_ingredient 'Apple Pie', 'Apple Big Apple' do
      assert_selector '.recipe-meal--ingredient--quantity', text: '0.03'
      assert_selector '.recipe-meal--ingredient--amount', text: '6'
      click_on 'Remove meal ingredient'
    end

    assert_selector '.flash', text: 'Meal ingredient deleted'

    within_recipe_meal 'Apple Pie' do
      assert_no_text 'Apple Big Apple'
    end
  end

  private

  def within_recipe_meal(recipe_name, &)
    within(find('li.recipe-meal', text: recipe_name), &)
  end

  def within_recipe_meal_ingredient(recipe_name, ingredient_name, &)
    within_recipe_meal(recipe_name) do
      within(find('li.recipe-meal--ingredient', text: ingredient_name), &)
    end
  end
end
