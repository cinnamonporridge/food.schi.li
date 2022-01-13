require 'test_helper'

class FoodFlowsTest < ActionDispatch::IntegrationTest
  def setup
    login_user(users(:daisy))
  end

  # foods
  test 'user visits foods index page' do
    get foods_path
    assert_response :success
    assert_select 'h1', 'Foods'
    assert_select 'a', 'Add food'
  end

  test 'user visits apple food page' do
    get food_path(foods(:apple))
    assert_response :success
    assert_select 'h1', 'Apple'

    assert_select 'h2', 'Nutrition facts'
    assert_select 'h2', 'Portions'

    assert_select 'a', 'Edit'
    assert_select 'a', 'Add portion'
  end

  test 'user adds a new food' do
    get new_food_path
    assert_response :success
    assert_select 'h1', 'New food'
    assert_select "button[type='submit']"
    assert_select 'a', 'Cancel'

    assert_input_fields_present

    post '/foods',
         params: {
           food: {
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
    assert_equal 'Food added', flash[:notice]
  end

  test 'user submits empty form' do
    post '/foods',
         params: {
           food: {
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
  test 'user edits a food' do
    get food_path(foods(:apple))
    assert_select '.vegan-badge', count: 0

    assert_select 'a', text: 'Edit'

    get edit_food_path(foods(:apple))
    assert_response :success
    assert_select 'h1', 'Edit food'
    assert_select "button[type='submit']"
    assert_select 'a', 'Cancel'

    assert_input_fields_present

    put "/foods/#{foods(:apple).id}",
        params: {
          food: {
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
    assert_equal 'Food updated', flash[:notice]
    assert_select '.vegan-badge'
  end
  # rubocop:enable Metrics/BlockLength

  test 'user cannot delete a food that is used in recipe' do
    get food_path(foods(:milk))
    assert_response :success
    assert_select 'h1', 'Milk'
    assert_select 'a', text: 'Delete food', count: 0

    delete "/foods/#{foods(:milk).id}"
    assert_response :success
    assert_equal 'Deletion not possible', flash[:error]

    assert_select '.flash-messages', text: 'Deletion not possible'
  end

  test 'user cannot delete a food that is used in a meal / journal day' do
    food = foods(:celery_old)

    delete "/foods/#{food.id}"
    assert_response :success
    assert_equal 'Deletion not possible', flash[:error]

    assert_select '.flash-messages', 'Deletion not possible'
  end

  test 'user can delete food that is not used in a recipe' do
    get food_path(foods(:sugar))
    assert_response :success
    assert_select 'h1', 'Sugar'
    assert_select '.food-actions button', 'Delete'

    delete "/foods/#{foods(:sugar).id}"
    follow_redirect!
    assert_response :success
    assert_equal 'Food deleted', flash[:notice]
  end

  private

  def assert_input_fields_present
    assert_select '#food_name'
    assert_select '#food_unit'
    assert_select '#food_kcal'
    assert_select '#food_carbs'
    assert_select '#food_carbs_sugar_part'
    assert_select '#food_protein'
    assert_select '#food_fat'
    assert_select '#food_fat_saturated'
    assert_select '#food_fiber'
    assert_select '#food_vegan'
  end
end
