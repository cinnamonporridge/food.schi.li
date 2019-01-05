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

    assert_select 'a.warning.button', 'Edit'
    assert_select 'a.primary.button', 'New portion'
  end

  test 'user adds a new nutrition' do
    get new_nutrition_path
    assert_response :success
    assert_select 'h1', 'New nutrition'
    assert_select "input[type='submit'][value='Create Nutrition']"
    assert_select 'a.secondary.button', 'Cancel'

    assert_input_fields_present

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
          fiber: '',
          vegan: ''
        }
      }
    assert_response :success
    assert_equal 'Invalid input', flash[:error]

    post '/nutritions',
      params: {
        nutrition: {
          unit: 'gram',
          name: 'Beetroot',
          kcal: 180,
          carbs: 52,
          carbs_sugar_part: 4,
          protein: 12,
          fat: 88,
          fat_saturated: 87,
          fiber: 3,
          vegan: '1'
        }
      }
    follow_redirect!
    assert_response :success
    assert_equal 'Nutrition added', flash[:notice]
  end

  test 'user edits a nutrition' do
    get nutrition_path(nutritions(:apple))
    assert_select '.vegan-icon i.fa-leaf.fa-superlightgrey', { count: 1 }, 'Not vegan icon should be shown before update'
    assert_select 'a', text: 'Edit'

    get edit_nutrition_path(nutritions(:apple))
    assert_response :success
    assert_select 'h1', 'Edit nutrition'
    assert_select "input[type='submit'][value='Update Nutrition']"
    assert_select 'a.secondary.button', 'Cancel'

    assert_input_fields_present

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
          fiber: 1,
          vegan: '1'
        }
      }

    follow_redirect!
    assert_response :success
    assert_equal 'Nutrition updated', flash[:notice]
    assert_select '.vegan-icon i.fa-leaf.fa-green', { count: 1 }, 'Vegan icon should be shown after update'
  end

  test 'user cannot delete a nutrition that is used in recipe' do
    get nutrition_path(nutritions(:milk))
    assert_response :success
    assert_select 'h1', 'Milk'
    assert_select 'a.alert.button', false, 'Apple should not show a delete button'

    delete "/nutritions/#{nutritions(:milk).id}"
    assert_response :success
    assert_equal 'Nutrition cannot be deleted, it is used in at least on recipe', flash[:error]
  end

  test 'user can delete nutrition that is not used in a recipe' do
    get nutrition_path(nutritions(:sugar))
    assert_response :success
    assert_select 'h1', 'Sugar'
    assert_select 'a.alert.button', 'Delete'

    delete "/nutritions/#{nutritions(:sugar).id}"
    follow_redirect!
    assert_response :success
    assert_equal 'Nutrition deleted', flash[:notice]
  end

  def assert_input_fields_present
    assert_select '#nutrition_name'
    assert_select '#nutrition_unit'
    assert_select '#nutrition_kcal'
    assert_select '#nutrition_carbs'
    assert_select '#nutrition_carbs_sugar_part'
    assert_select '#nutrition_protein'
    assert_select '#nutrition_fat'
    assert_select '#nutrition_fat_saturated'
    assert_select '#nutrition_fiber'
    assert_select '#nutrition_vegan'
  end
end
