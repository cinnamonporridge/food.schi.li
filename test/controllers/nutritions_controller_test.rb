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

  test 'recipe turns vegan after changing only non-vegan ingredient / nutrition to vegan' do
    recipe = recipes(:non_vegan_milk_banana)
    non_vegan_ingredient = ingredients(:milk_in_non_vegan_milk_banana)
    nutrition = non_vegan_ingredient.nutrition

    assert_changes 'recipe.vegan?', from: false, to: true do
      assert_changes 'nutrition.vegan?', from: false, to: true do
        patch nutrition_path(nutrition),
              params: {
                nutrition: {
                  vegan: '1'
                }
              }
        nutrition.reload
      end
      recipe.reload
    end
  end

  test 'recipe turns non-vegan after changing one ingredient / nutrition to non-vegan' do
    recipe = recipes(:vegan_peanut_butter_banana)
    vegan_ingredient = ingredients(:peanut_butter_in_vegan_peanut_butter_banana)
    nutrition = vegan_ingredient.nutrition

    assert_changes 'recipe.vegan?', from: true, to: false do
      assert_changes 'nutrition.vegan?', from: true, to: false do
        patch nutrition_path(nutrition),
              params: {
                nutrition: {
                  vegan: '0'
                }
              }
        nutrition.reload
      end
      recipe.reload
    end
  end
end
