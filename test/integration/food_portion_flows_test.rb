require 'test_helper'

class FoodPortionFlowsTest < ActionDispatch::IntegrationTest
  def setup
    login_user(users(:daisy))
  end

  test 'user adds a food portion' do
    get new_food_portion_path(foods(:apple))
    assert_response :success
    assert_select 'h1', 'New portion for Apple'
    assert_select "button[type='submit']"
    assert_select 'a', 'Cancel'

    post "/foods/#{foods(:apple).id}/portions",
         params: {
           portion: {
             name: '',
             amount: ''
           }
         }
    assert_response :success
    assert_equal 'Invalid input', flash[:error]

    post "/foods/#{foods(:apple).id}/portions",
         params: {
           portion: {
             name: 'Regular apple',
             amount: '160'
           }
         }
    follow_redirect!
    assert_response :success
    assert_equal 'Portion added', flash[:notice]
  end

  test 'user cannot edit the default food portion' do
    # edit
    default_portion = portions(:apple_default_portion)
    get edit_food_portion_path(default_portion.food, default_portion)
    follow_redirect!
    assert_response :success
    assert_select 'h1', 'Apple'
    assert_equal 'Default portion cannot be edited or deleted', flash[:alert]

    # update
    put "/foods/#{default_portion.food.id}/portions/#{default_portion.id}",
        params: {
          portion: {
            name: 'Some invalid value',
            amount: '999'
          }
        }
    follow_redirect!
    assert_response :success
    assert_select 'h1', 'Apple'
    assert_equal 'Default portion cannot be edited or deleted', flash[:alert]
  end

  test 'user cannot delete the default food portion' do
    default_portion = portions(:apple_default_portion)
    delete food_portion_path(default_portion.food, default_portion)
    follow_redirect!
    assert_response :success
    assert_select 'h1', 'Apple'
    assert_equal 'Default portion cannot be edited or deleted', flash[:alert]
  end

  test 'user edits a food portion' do
    big_apple = portions(:big_apple_portion)
    get edit_food_portion_path(big_apple.food, big_apple)
    assert_response :success
    assert_select 'h1', 'Edit portion for Apple'
    assert_select "button[type='submit']"
    assert_select 'a', 'Cancel'

    put "/foods/#{big_apple.food.id}/portions/#{big_apple.id}",
        params: {
          portion: {
            name: 'Even Bigger Apple',
            amount: '300'
          }
        }

    follow_redirect!
    assert_response :success
    assert_select 'h1', 'Apple'
    assert_equal 'Portion updated', flash[:notice]
  end

  test 'user deletes a food portion' do
    skip
    big_apple = portions(:big_apple_portion)
    delete food_portion_path(big_apple.food, big_apple)
    follow_redirect!
    assert_response :success
    assert_select 'h1', 'Apple'
    assert_equal 'Portion deleted', flash[:notice]
  end
end
