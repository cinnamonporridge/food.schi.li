require 'test_helper'

class FoodsControllerTest < ActionDispatch::IntegrationTest
  def setup
    sign_in_user :daisy
  end

  # index
  test 'get index' do
    get foods_path
    assert_response :success
  end

  # show
  test 'get show of own food' do
    get food_path(foods(:apple))
    assert_response :success
  end

  test 'cannot get show other users food' do
    assert_raises ActiveRecord::RecordNotFound do
      get food_path(foods(:apricot))
    end
  end

  # new
  test 'get new' do
    get new_food_path
    assert_response :success
  end

  # create
  test 'post create creates food for own' do
    assert_difference -> { users(:daisy).foods.count }, +1 do
      post foods_path, params: {
        food: {
          name: 'Pineapple',
          vegan: '1',
          kcal: '74',
          carbs: '19.58',
          carbs_sugar_part: '14.35',
          protein: '0.85',
          fat: '0.19',
          fat_saturated: '0.014',
          fiber: '2.2'
        }
      }
    end
    follow_redirect!
    assert_response :success

    food = users(:daisy).foods.last
    assert_equal 'Pineapple', food.name
  end

  # edit
  test 'get edit of own food' do
    get edit_food_path(foods(:apple))
    assert_response :success
  end

  test 'cannot get edit of other users food' do
    assert_raises ActiveRecord::RecordNotFound do
      get edit_food_path(foods(:apricot))
    end
  end

  # destroy
  test 'delete destroy of own food' do
    assert_difference -> { users(:daisy).foods.count }, -1 do
      delete food_path(foods(:sugar))
    end
  end

  test 'cannot delete destroy of other users food' do
    assert_raises ActiveRecord::RecordNotFound do
      delete food_path(foods(:apricot))
    end
  end

  test 'declare a food to be vegan' do
    food = foods(:apple)

    assert_changes 'food.vegan?', from: true, to: false do
      patch food_path(food), params: {
        food: {
          vegan: '0'
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
