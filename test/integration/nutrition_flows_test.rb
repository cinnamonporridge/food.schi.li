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
    assert_select 'a', 'Add nutrition'
  end

  test 'user visits apple nutrition page' do
    get nutrition_path(nutritions(:apple))
    assert_response :success
    assert_select 'h1', 'Apple'

    assert_select 'h2', 'Nutrition facts'
    assert_select 'h2', 'Portions'

    assert_select 'a', 'Edit'
    assert_select 'a', 'Add portion'
  end

  test 'user adds a new nutrition' do
    get new_nutrition_path
    assert_response :success
    assert_select 'h1', 'New nutrition'
    assert_select "input[type='submit'][value='Create Nutrition']"
    assert_select 'a', 'Cancel'

    assert_input_fields_present

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

  test 'user submits empty form' do
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
  end

  # rubocop:disable Metrics/BlockLength
  test 'user edits a nutrition' do
    get nutrition_path(nutritions(:apple))
    assert_select '.vegan-indicator', text: 'Not vegan'

    assert_select 'a', text: 'Edit'

    get edit_nutrition_path(nutritions(:apple))
    assert_response :success
    assert_select 'h1', 'Edit nutrition'
    assert_select "input[type='submit'][value='Update Nutrition']"
    assert_select 'a', 'Cancel'

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
    assert_select '.vegan-indicator', text: 'Vegan'
  end
  # rubocop:enable Metrics/BlockLength

  test 'user cannot delete a nutrition that is used in recipe' do
    get nutrition_path(nutritions(:milk))
    assert_response :success
    assert_select 'h1', 'Milk'
    assert_select 'a', text: 'Delete nutrition', count: 0

    delete "/nutritions/#{nutritions(:milk).id}"
    assert_response :success
    assert_equal 'Deletion not possible', flash[:error]

    assert_select 'div.card-yellow', text: 'Deletion not possible'
  end

  test 'user cannot delete a nutrition that is used in a meal / journal day' do
    nutrition = nutritions(:celery_old)

    delete "/nutritions/#{nutrition.id}"
    assert_response :success
    assert_equal 'Deletion not possible', flash[:error]

    assert_select 'div.card-yellow', 'Deletion not possible'
  end

  test 'user can delete nutrition that is not used in a recipe' do
    get nutrition_path(nutritions(:sugar))
    assert_response :success
    assert_select 'h1', 'Sugar'
    assert_select 'button', 'Delete nutrition'

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
