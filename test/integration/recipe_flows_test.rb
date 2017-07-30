require 'test_helper'

class RecipeFlowsTest < ActionDispatch::IntegrationTest

  def setup
    login_user(users(:john))
  end

  test 'user visits recipes index page' do
    get recipes_path
    assert_response :success
    assert_select 'h1', 'Recipes'
    assert_select 'a.primary.button', 'New Recipe'

    first_recipe, second_recipe, *rest = css_select('li.food-list-group-item span')

    assert_equal 'Anchovy Soup', first_recipe.inner_text.strip, 'Anchovy Soup should be listed before Apple Pie'
    assert_equal 'Apple Pie'   , second_recipe.inner_text.strip, 'Apple Pie should be listed after Anchovy Soup'
  end

  test 'user visits recipe page' do
    get recipe_path(recipes(:apple_pie))
    assert_response :success
    assert_select 'h1', 'Apple Pie'
    assert_select 'h2', 'Nutritions'
    assert_select 'a.warning.button', 'Edit'
    assert_select 'a.alert.button', 'Delete'

    expected_header2 = ['Ingredients for 6 servings', 'Nutritions', 'Macronutrients']
    css_select('h2').each_with_index do |header2,i|
      assert_equal expected_header2[i], header2.text.strip
    end
  end

  test 'user adds a recipe' do
    get new_recipe_path
    assert_response :success
    assert_select 'h1', 'New Recipe'
    assert_select "input[type='submit'][value='Create Recipe']"
    assert_select 'a.secondary.button', 'Cancel'

    post '/recipes',
      params: {
        recipe: {
          name: '',
          servings: ''
        }
      }
    assert_response :success
    assert_equal 'Invalid input', flash[:error]

    post '/recipes',
      params: {
        recipe: {
          name: 'Lasagne',
          servings: '4'
        }
      }
    follow_redirect!
    assert_response :success
    assert_equal 'Recipe added', flash[:notice]
  end

  test 'user edits a recipe' do
    recipe = recipes(:apple_pie)
    get edit_recipe_path(recipe)
    assert_response :success
    assert_select 'h1', 'Edit Apple Pie'
    assert_select "input[type='submit'][value='Update Recipe']"
    assert_select 'a.secondary.button', 'Cancel'

    put "/recipes/#{recipe.id}",
      params: {
        recipe: {
          name: 'Apfelkuchen',
          servings: '80'
        }
      }
    follow_redirect!
    assert_response :success
    assert_equal 'Recipe updated', flash[:notice]
  end

  test 'user deletes a recipe' do
    delete recipe_path(recipes(:apple_pie))
    follow_redirect!
    assert_response :success
    assert_select 'h1', 'Recipes'
    assert_equal 'Recipe deleted', flash[:notice]
  end
end
