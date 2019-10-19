require 'test_helper'

class NutritionFlowsTest < ActionDispatch::IntegrationTest
  def setup
    login_user(users(:john))
  end

  test 'user adds a nutrition portion' do
    get new_nutrition_portion_path(nutritions(:apple))
    assert_response :success
    assert_select 'h1', 'New portion for Apple'
    assert_select "input[type='submit'][value='Create Portion']"
    assert_select 'a.secondary.button', 'Cancel'

    post "/nutritions/#{nutritions(:apple).id}/portions",
         params: {
           portion: {
             name: '',
             amount: ''
           }
         }
    assert_response :success
    assert_equal 'Invalid input', flash[:error]

    post "/nutritions/#{nutritions(:apple).id}/portions",
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

  test 'user cannot edit the default nutrition portion' do
    # edit
    default_portion = portions(:apple_default_portion)
    get edit_nutrition_portion_path(default_portion.nutrition, default_portion)
    follow_redirect!
    assert_response :success
    assert_select 'h1', 'Apple'
    assert_equal 'Default portion cannot be edited or deleted', flash[:alert]

    # update
    put "/nutritions/#{default_portion.nutrition.id}/portions/#{default_portion.id}",
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

  test 'user cannot delete the default nutrition portion' do
    default_portion = portions(:apple_default_portion)
    delete nutrition_portion_path(default_portion.nutrition, default_portion)
    follow_redirect!
    assert_response :success
    assert_select 'h1', 'Apple'
    assert_equal 'Default portion cannot be edited or deleted', flash[:alert]
  end

  test 'user edits a nutrition portion' do
    big_apple = portions(:big_apple_portion)
    get edit_nutrition_portion_path(big_apple.nutrition, big_apple)
    assert_response :success
    assert_select 'h1', 'Edit portion for Apple'
    assert_select "input[type='submit'][value='Update Portion']"
    assert_select 'a.secondary.button', 'Cancel'

    put "/nutritions/#{big_apple.nutrition.id}/portions/#{big_apple.id}",
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

  test 'user deletes a nutrition portion' do
    skip
    big_apple = portions(:big_apple_portion)
    delete nutrition_portion_path(big_apple.nutrition, big_apple)
    follow_redirect!
    assert_response :success
    assert_select 'h1', 'Apple'
    assert_equal 'Portion deleted', flash[:notice]
  end
end
