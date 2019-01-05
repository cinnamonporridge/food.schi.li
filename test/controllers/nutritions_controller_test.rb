require 'test_helper'

class NutritionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    login_user(users(:john))
  end

  test 'declare a nutrition to be vegan' do
    nutrition = nutritions(:apple)

    assert_changes 'nutrition.vegan?', from: false, to: true do
      patch nutrition_path(nutrition), params: {
        nutrition: {
          vegan: '1'
        }
      }
      nutrition.reload
    end
  end
end
