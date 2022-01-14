require 'test_helper'

class FoodsControllerTest < ActionDispatch::IntegrationTest
  def setup
    login_user(users(:daisy))
  end

  test 'declare a food to be vegan' do
    food = foods(:apple)

    assert_changes 'food.vegan?', from: false, to: true do
      patch food_path(food), params: {
        food: {
          vegan: '1'
        }
      }
      food.reload
    end
  end

  test 'recipe turns vegan after changing only non-vegan ingredient / food to vegan' do
    recipe = recipes(:non_vegan_milk_banana)
    non_vegan_ingredient = ingredients(:milk_in_non_vegan_milk_banana)
    food = non_vegan_ingredient.food

    assert_changes 'recipe.vegan?', from: false, to: true do
      assert_changes 'food.vegan?', from: false, to: true do
        patch food_path(food),
              params: {
                food: {
                  vegan: '1'
                }
              }
        food.reload
      end
      recipe.reload
    end
  end

  test 'recipe turns non-vegan after changing one ingredient / food to non-vegan' do
    recipe = recipes(:vegan_peanut_butter_banana)
    vegan_ingredient = ingredients(:peanut_butter_in_vegan_peanut_butter_banana)
    food = vegan_ingredient.food

    assert_changes 'recipe.vegan?', to: false do
      assert_changes 'food.vegan?', to: false do
        patch food_path(food),
              params: {
                food: {
                  vegan: '0'
                }
              }
        food.reload
      end
      recipe.reload
    end
  end

  test 'cannot delete food that is used in a recipe' do
    food = foods(:milk)
    delete food_path(food)
    assert_response :success
    assert_equal 'Deletion not allowed', flash[:notice]
    assert food.reload.persisted?
  end

  test 'cannot delete food that is used in a meal / journal day' do
    food = foods(:celery_old)
    delete food_path(food)
    assert_response :success
    assert_equal 'Deletion not allowed', flash[:notice]
    assert food.reload.persisted?
  end
end
