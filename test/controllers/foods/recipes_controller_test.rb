require 'test_helper'

class Nutritions::RecipesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_user(users(:john))
  end

  test '#index' do
    nutrition = nutritions(:banana)
    get nutrition_recipes_path(nutrition)
    assert_response :success
  end
end
