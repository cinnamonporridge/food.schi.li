require 'test_helper'

class RecipeMeals::IngredientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recipe_meal = meals(:daisys_apple_pie_meal_on_february_fifth)
    @recipe_meal_ingredient = meal_ingredients(:daisys_milk_from_apple_pie_meal_ingredient_on_february_fifth)
  end

  # new
  test 'get #new' do
    login_user :daisy
    get new_recipe_meal_ingredient_path(@recipe_meal)
    assert_response :success
  end

  test 'cannot get #new for other' do
    login_user :john
    assert_raises(ActiveRecord::RecordNotFound) {
      get new_recipe_meal_ingredient_path(@recipe_meal)
    }
  end

  # create
  test 'post #create' do
    login_user :daisy
    assert_difference -> { @recipe_meal.meal_ingredients.count }, +1 do
      post recipe_meal_ingredients_path(@recipe_meal), params: {
        recipe_meal_ingredient: {
          portion_name: 'Sugar Cube (25g)',
          amount_in_measure: '2',
          measure: 'piece'
        }
      }
      follow_redirect!
      assert_response :success
      assert_notice 'Meal ingredient added'
    end

    last_meal_ingredient = @recipe_meal.meal_ingredients.last

    assert_equal portions(:sugar_cube_portion), last_meal_ingredient.portion
    assert_equal 'piece', last_meal_ingredient.measure
    assert_equal 50.0, last_meal_ingredient.amount
  end

  test 'cannot post #create for other' do
    login_user :john
    assert_raises(ActiveRecord::RecordNotFound) {
      post recipe_meal_ingredients_path(@recipe_meal), params: {}
    }
  end

  # edit
  test 'get #edit' do
    login_user :daisy
    get edit_recipe_meal_ingredient_path(@recipe_meal, @recipe_meal_ingredient)
    assert_response :success
  end

  test 'cannot get #edit for other' do
    login_user :john
    assert_raises(ActiveRecord::RecordNotFound) {
      get edit_recipe_meal_ingredient_path(@recipe_meal, @recipe_meal_ingredient)
    }
  end

  # update
  test 'patch #update' do
    login_user :daisy

    assert_changes -> { @recipe_meal_ingredient.amount }, to: 50.0 do
      patch recipe_meal_ingredient_path(@recipe_meal, @recipe_meal_ingredient), params: {
        recipe_meal_ingredient: {
          portion_name: 'Milk (100ml)',
          amount_in_measure: '50',
          measure: 'unit'
        }
      }
      follow_redirect!
      assert_response :success
      @recipe_meal_ingredient.reload
      assert_notice 'Meal ingredient updated'
    end
  end

  test 'cannot patch #update for other' do
    login_user :john
    assert_raises(ActiveRecord::RecordNotFound) {
      patch recipe_meal_ingredient_path(@recipe_meal, @recipe_meal_ingredient), params: {}
    }
  end

  # destry
  test 'delete #destroy' do
    login_user :daisy

    assert_difference -> { @recipe_meal.meal_ingredients.count }, -1 do
      delete recipe_meal_ingredient_path(@recipe_meal, @recipe_meal_ingredient)
      follow_redirect!
      assert_response :success
      assert_notice 'Meal ingredient deleted'
    end

    assert_raises(ActiveRecord::RecordNotFound) {
      @recipe_meal_ingredient.reload
    }
  end

  test 'cannot delete #destroy for other' do
    login_user :john
    assert_raises(ActiveRecord::RecordNotFound) {
      delete recipe_meal_ingredient_path(@recipe_meal, @recipe_meal_ingredient)
    }
  end
end
