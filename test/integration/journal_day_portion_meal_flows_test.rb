require 'test_helper'

class JournalDayPortionMealIngredientFlowsTest < ActionDispatch::IntegrationTest
  def setup
    login_user :daisy
    @february_first = journal_days(:daisy_february_first)
  end

  test 'daisy sees two meals for february first journal day' do
    get journal_day_path(@february_first)
    assert_response :success

    assert_select 'ul#meal-items li', count: 2
  end

  test 'daisy adds a new piece portion meal' do
    get new_journal_day_meal_ingredient_path(@february_first)
    assert_response :success

    assert_select 'h1', 'Add portion meal'
    assert_select 'a', 'Cancel'
    assert_select 'input[type="submit"][value="Create meal"]'

    post journal_day_meal_ingredients_path(@february_first),
         params: {
           meal_ingredient: {
             portion_name: 'Apple Big Apple (200g)',
             amount_in_measure: '2.5',
             measure: 'piece'
           }
         }
    follow_redirect!
    assert_response :success

    assert_equal 'Meal added', flash[:notice]
  end

  test 'daisy submits empty form' do
    post journal_day_meal_ingredients_path(@february_first),
         params: {
           meal_ingredient: {
             portion_id: '',
             amount_in_measure: '',
             measure: ''
           }
         }
    assert_response :success
    assert_equal 'Invalid input', flash[:error]
  end

  test 'daisy adds a new unit portion meal_ingredient' do
    post journal_day_meal_ingredients_path(@february_first),
         params: {
           meal_ingredient: {
             portion_name: 'Milk (100ml)',
             amount_in_measure: '250',
             measure: 'unit'
           }
         }
    follow_redirect!
    assert_response :success

    assert_equal 'Meal added', flash[:notice]
  end

  test 'daisy deletes a meal' do
    meal_ingredient = meal_ingredients(:daisys_big_apple_on_february_first)
    delete journal_day_meal_ingredient_path(meal_ingredient.journal_day, meal_ingredient)
    follow_redirect!
    assert_response :success

    assert_equal 'Meal deleted', flash[:notice]
  end

  # tenant tests

  test 'daisy cannot add a portion meal for john' do
    milk_portion = portions(:milk_default_portion)
    johns_journal_day = journal_days(:john_january_first)

    get new_journal_day_meal_ingredient_path(johns_journal_day)
    follow_redirect!
    assert_response :success

    assert_equal 'That journal day does not exist or does not belong to you', flash[:warning]

    post journal_day_meal_ingredients_path(johns_journal_day),
         params: {
           meal_ingredient: {
             portion_id: milk_portion.id,
             amount_in_measure: '250',
             measure: 'unit'
           }
         }
    follow_redirect!
    assert_response :success

    assert_equal 'That journal day does not exist or does not belong to you', flash[:warning]
  end

  test 'daisy cannot edit a meal for john' do
    milk_portion = portions(:milk_default_portion)
    johns_meal_ingredient = meal_ingredients(:johns_apple_on_january_first)

    get edit_journal_day_meal_ingredient_path(johns_meal_ingredient.journal_day, johns_meal_ingredient)
    follow_redirect!
    assert_response :success

    assert_equal 'That meal does not exist or does not belong to you', flash[:warning]

    patch journal_day_meal_ingredient_path(johns_meal_ingredient.journal_day, johns_meal_ingredient),
          params: {
            meal_ingredient: {
              portion_id: milk_portion.id,
              amount_in_measure: '250',
              measure: 'unit'
            }
          }
    follow_redirect!
    assert_response :success

    assert_equal 'That meal does not exist or does not belong to you', flash[:warning]
  end

  test 'daisy cannot delete a meal for john' do
    johns_meal_ingredient = meal_ingredients(:johns_apple_on_january_first)
    delete journal_day_meal_ingredient_path(johns_meal_ingredient.journal_day, johns_meal_ingredient)
    follow_redirect!
    assert_response :success
    assert_equal 'That meal does not exist or does not belong to you', flash[:warning]
  end
end
