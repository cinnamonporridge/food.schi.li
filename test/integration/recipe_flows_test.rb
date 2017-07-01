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
  end

  test 'user visits recipe page' do
    get recipe_path(recipes(:apple_pie))
    assert_response :success
    assert_select 'h1', 'Apple Pie'
    assert_select 'a.secondary.button', 'Edit'
    assert_select 'a.warning.button', 'Delete'
  end
end
