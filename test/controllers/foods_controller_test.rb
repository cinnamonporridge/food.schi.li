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
    get food_path(foods(:milk))
    assert_response :success
  end

  test 'get show of global food' do
    get food_path(foods(:apple))
    assert_response :success
  end

  test 'cannot get show other users food' do
    assert_not_get food_path(foods(:maple_syrup))
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
    get edit_food_path(foods(:milk))
    assert_response :success
  end

  test 'admin gets edit of global food' do
    get edit_food_path(foods(:apple))
    assert_response :success
  end

  test 'non-admin cannot get edit of global food' do
    sign_out
    sign_in_user :john
    assert_not_get edit_food_path(foods(:apple))
  end

  test 'cannot get edit of other users food' do
    assert_not_get edit_food_path(foods(:maple_syrup))
  end

  # update
  test 'patch update of own food' do
    food = foods(:milk)

    assert_changes -> { food.kcal }, to: 136 do
      patch food_path(food), params: {
        food: {
          kcal: '136',
          carbs: '136',
          carbs_sugar_part: '13.6',
          protein: '136',
          fat: '136',
          fat_saturated: '13.6',
          fiber: '136'
        }
      }
      follow_redirect!
      assert_response :success
      food.reload
    end
  end

  test 'admin patch update of global food' do
    food = foods(:apple)

    assert_changes -> { food.kcal }, to: 103 do
      patch food_path(food), params: {
        food: {
          kcal: '103',
          carbs: '103',
          carbs_sugar_part: '10.3',
          protein: '103',
          fat: '103',
          fat_saturated: '10.3',
          fiber: '103'
        }
      }
      follow_redirect!
      assert_response :success
      food.reload
    end
  end

  test 'non-admin cannot patch update of global food' do
    sign_out
    sign_in_user :john
    assert_not_patch food_path(foods(:apple))
  end

  test 'cannot patch update of other food' do
    assert_not_patch food_path(foods(:maple_syrup))
  end

  # destroy
  test 'delete destroy of own food' do
    assert_difference -> { users(:daisy).foods.count }, -1 do
      delete food_path(foods(:sugar))
    end
  end

  test 'admin delete destroy of (unused) global food' do
    food = create_global_mango

    assert_difference -> { users(:global).foods.count }, -1 do
      delete food_path(food)
      follow_redirect!
      assert_response :success
    end

    assert_raises ActiveRecord::RecordNotFound do
      food.reload
    end
  end

  test 'non-admin cannot delete destroy of (unused) global food' do
    food = create_global_mango

    sign_out
    sign_in_user :john
    assert_not_delete food_path(food)
  end

  test 'cannot delete destroy of other food' do
    food = users(:john).foods.create!(name: 'Blue cheese', unit: 'gram',
                                      kcal: 1, carbs: 1, carbs_sugar_part: 1, protein: 1,
                                      fat: 1, fat_saturated: 1, fiber: 1)
    assert_not_delete food_path(food)
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

  # vegan
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
    non_vegan_ingredient = recipe_ingredients(:milk_in_non_vegan_milk_banana)
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
    vegan_ingredient = recipe_ingredients(:peanut_butter_in_vegan_peanut_butter_banana)
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

  test 'admin can globalize non-global food' do
    food = foods(:milk)

    assert_changes -> { food.user }, to: User.find_global_user do
      post globalize_food_path(food)
      follow_redirect!
      assert_response :success
      assert_equal 'Food has been made global', flash[:notice]
      food.reload
    end
  end

  test 'non-admin cannot globalize local food' do
    sign_out
    sign_in_user :john
    assert_not_post(
      globalize_food_path(foods(:maple_syrup)),
      error: ActionPolicy::Unauthorized
    )
  end

  private

  def create_global_mango
    users(:global).foods.create!(name: 'Mango',
                                 kcal: '997', carbs: '997', carbs_sugar_part: '99.7', protein: '997',
                                 fat: '997', fat_saturated: '99.7', fiber: '997',
                                 vegan: true)
  end
end
