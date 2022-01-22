require 'test_helper'

class Meals::IngredientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @meal = meals(:daisys_apple_pie_meal_on_february_fifth)
    @meal_ingredient = meal_ingredients(:daisys_milk_from_apple_pie_meal_ingredient_on_february_fifth)
  end

  # new
  test 'get #new' do
    login_user :daisy
    get new_meal_ingredient_path(@meal)
    assert_response :success
  end

  test 'cannot get #new for other' do
    login_user :john
    assert_raises(ActiveRecord::RecordNotFound) {
      get new_meal_ingredient_path(@meal)
    }
  end

  # create
  test 'post #create' do
    login_user :daisy
    assert_difference -> { @meal.meal_ingredients.count }, +1 do
      post meal_ingredients_path(@meal), params: {
        meal_ingredient: {
          portion_name: 'Sugar Cube (25g)',
          amount_in_measure: '2',
          measure: 'piece'
        }
      }
      follow_redirect!
      assert_response :success
      assert_notice 'Meal ingredient added'
    end

    last_meal_ingredient = @meal.meal_ingredients.last

    assert_equal portions(:sugar_cube_portion), last_meal_ingredient.portion
    assert_equal 'piece', last_meal_ingredient.measure
    assert_equal 50.0, last_meal_ingredient.amount
  end

  test 'cannot post #create for other' do
    login_user :john
    assert_raises(ActiveRecord::RecordNotFound) {
      post meal_ingredients_path(@meal), params: {}
    }
  end

  # edit
  test 'get #edit' do
    login_user :daisy
    get edit_meal_ingredient_path(@meal, @meal_ingredient)
    assert_response :success
  end

  test 'cannot get #edit for other' do
    login_user :john
    assert_raises(ActiveRecord::RecordNotFound) {
      get edit_meal_ingredient_path(@meal, @meal_ingredient)
    }
  end

  # update
  test 'patch #update' do
    login_user :daisy

    assert_changes -> { @meal_ingredient.amount }, to: 50.0 do
      patch meal_ingredient_path(@meal, @meal_ingredient), params: {
        meal_ingredient: {
          portion_name: 'Milk (100ml)',
          amount_in_measure: '50',
          measure: 'unit'
        }
      }
      follow_redirect!
      assert_response :success
      @meal_ingredient.reload
      assert_notice 'Meal ingredient updated'
    end
  end

  test 'cannot patch #update for other' do
    login_user :john
    assert_raises(ActiveRecord::RecordNotFound) {
      patch meal_ingredient_path(@meal, @meal_ingredient), params: {}
    }
  end

  # destry
  test 'delete #destroy' do
    login_user :daisy

    assert_difference -> { @meal.meal_ingredients.count }, -1 do
      delete meal_ingredient_path(@meal, @meal_ingredient)
      follow_redirect!
      assert_response :success
      assert_notice 'Meal ingredient deleted'
    end

    assert_raises(ActiveRecord::RecordNotFound) {
      @meal_ingredient.reload
    }
  end

  test 'cannot delete #destroy for other' do
    login_user :john
    assert_raises(ActiveRecord::RecordNotFound) {
      delete meal_ingredient_path(@meal, @meal_ingredient)
    }
  end
end
