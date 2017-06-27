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
          multiplier: ''
        }
      }
    assert_response :success
    assert_equal 'Invalid input', flash[:error]
  end
end
