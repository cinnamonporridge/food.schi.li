require 'test_helper'

class Recipes::CopiesControllerTest < ActionDispatch::IntegrationTest
  attr_reader :recipe

  def setup
    login_user :daisy
    @recipe = recipes(:peanut_butter_bread)
  end

  test 'get new' do
    get new_recipe_copy_path(recipe)
    assert_response :success
  end

  test 'post create' do
    assert_difference -> { Recipe.count }, 1 do
      post recipe_copy_path(recipe), params: {
        recipe_copy: {
          name: 'Recipe Copy'
        }
      }
    end
    follow_redirect!
    assert_response :success
  end

  test 'post create invalid' do
    post recipe_copy_path(recipe), params: {
      recipe_copy: {
        name: ''
      }
    }
    assert_response :success
  end
end
