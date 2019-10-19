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
    assert_select '.search input'

    first_recipe, second_recipe, *rest = css_select('li.food-list-group-item a')

    assert_equal 'Anchovy Soup', first_recipe.inner_text.strip, 'Anchovy Soup should be listed before Apple Pie'
    assert_equal 'Apple Pie', second_recipe.inner_text.strip, 'Apple Pie should be listed after Anchovy Soup'
  end

  test 'user sees pagination on index' do
    get recipes_path

    assert_changes -> { css_select('.pagination').count }, from: 0 do
      prepare_recipes_for_pagination
      get recipes_path
    end
  end

  test 'user searches for recipe' do
    get recipes_path(search_query: 'AnCHOVy')
    assert_response :success

    search_field = css_select('.search input[type=text]').first

    assert_equal 'AnCHOVy', search_field.attr(:value)

    recipe_list = css_select('li.food-list-group-item')

    assert_equal 1, recipe_list.count
  end

  test 'user visits recipe page' do
    get recipe_path(recipes(:apple_pie))
    assert_response :success
    assert_select 'h1', 'Apple Pie'
    assert_select 'h2', 'Nutritions'
    assert_select 'a.warning.button', 'Edit'
    assert_select 'a.alert.button', 'Delete'

    expected_header2 = ['Facts', 'Ingredients for 6 servings', 'Nutritions', 'Macronutrients']
    css_select('h2').each_with_index do |header2, i|
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

  private

  def prepare_recipes_for_pagination
    Kaminari.config.default_per_page.times do |i|
      Recipe.create!(name: "KAMINARI-RECIPE-#{i}")
    end
  end
end
