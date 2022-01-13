require 'test_helper'

class Foods::RecipesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_user(users(:daisy))
  end

  test '#index' do
    food = foods(:banana)
    get food_recipes_path(food)
    assert_response :success
  end
end
