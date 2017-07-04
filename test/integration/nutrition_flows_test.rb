require 'test_helper'

class NutritionFlowsTest < ActionDispatch::IntegrationTest
  def setup
    login_user(users(:john))
  end

  # nutritions
  test 'user visits nutritions index page' do
    get nutritions_path
    assert_response :success
    assert_select 'h1', 'Nutritions'
    assert_select 'a.primary.button', 'New nutrition'
  end

  test 'user visits apple nutrition page' do
    get nutrition_path(nutritions(:apple))
    assert_response :success
    assert_select 'h1', 'Apple'

    expected_header2 = ['100g contains', 'Portions', 'Used in 1 recipe']

    css_select('h2').each_with_index do |header2, i|
      assert_equal expected_header2[i], header2.text
    end

    assert_select 'a.secondary.button', 'Edit'
    assert_select 'a.primary.button', 'New portion'
  end

  test 'user adds a new nutrition' do
    get new_nutrition_path
    assert_response :success
    assert_select 'h1', 'New nutrition'
    assert_select "input[type='submit'][value='Create Nutrition']"
    assert_select 'a.secondary.button', 'Cancel'

    post '/nutritions',
      params: {
        nutrition: {
          unit: 'gram',
          name: '',
          kcal: '',
          carbs: '',
          carbs_sugar_part: '',
          protein: '',
          fat: '',
          fat_saturated: '',
          fiber: ''
        }
      }
    assert_response :success
    assert_equal 'Invalid input', flash[:error]

    post '/nutritions',
      params: {
        nutrition: {
          unit: 'gram',
          name: 'Banana',
          kcal: 180,
          carbs: 52,
          carbs_sugar_part: 4,
          protein: 12,
          fat: 88,
          fat_saturated: 87,
          fiber: 3
        }
      }
    follow_redirect!
    assert_response :success
    assert_equal 'Nutrition added', flash[:notice]
  end

  test 'user edits a nutrition' do
    get edit_nutrition_path(nutritions(:apple))
    assert_response :success
    assert_select 'h1', 'Edit nutrition'
    assert_select "input[type='submit'][value='Update Nutrition']"
    assert_select 'a.secondary.button', 'Cancel'

    put "/nutritions/#{nutritions(:apple).id}",
      params: {
        nutrition: {
          unit: 'gram',
          name: 'Apfel',
          kcal: 1,
          carbs: 1,
          carbs_sugar_part: 1,
          protein: 1,
          fat: 1,
          fat_saturated: 1,
          fiber: 1
        }
      }

    follow_redirect!
    assert_response :success
    assert_equal 'Nutrition updated', flash[:notice]
  end

end
