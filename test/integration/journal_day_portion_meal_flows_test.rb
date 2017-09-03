require 'test_helper'

class JournalDayPortionMealFlowsTest < ActionDispatch::IntegrationTest

  def setup
    login_user(users(:daisy))
    @february_first = journal_days(:daisy_february_first)
  end

  test 'daisy sees two meals for february first journal day' do
    get my_journal_day_path(@february_first)
    assert_response :success

    assert_select '.journal-day-meal-row', 2
  end

  test 'daisy adds a new piece portion meal' do
    get new_my_journal_day_meal_path(@february_first)
    assert_response :success

    big_apple_portion = portions(:big_apple_portion)

    assert_select 'h1', 'Add portion meal'
    assert_select 'a.secondary.button', 'Cancel'
    assert_select 'input[type="submit"][value="Create Meal"]'

    post my_journal_day_meals_path(@february_first),
      params: {
        meal: {
          portion_id: '',
          amount_in_measure: '',
          measure: ''
        }
      }
    assert_response :success
    assert_equal 'Invalid input', flash[:error]

    post my_journal_day_meals_path(@february_first),
      params: {
        meal: {
          portion_id: big_apple_portion.id,
          amount_in_measure: '2.5',
          measure: 'piece'
        }
      }
    follow_redirect!
    assert_response :success

    assert_equal 'Meal added', flash[:notice]
  end

  test 'daisy adds a new unit portion meal' do
    milk_portion = portions(:milk_default_portion)

    post my_journal_day_meals_path(@february_first),
      params: {
        meal: {
          portion_id: milk_portion.id,
          amount_in_measure: '250',
          measure: 'unit'
        }
      }
    follow_redirect!
    assert_response :success

    assert_equal 'Meal added', flash[:notice]
  end

  test 'daisy deletes a meal' do
    meal = meals(:daisys_big_apple_on_february_first)
    delete my_journal_day_meal_path(meal.journal_day, meal)
    follow_redirect!
    assert_response :success

    assert_equal 'Meal deleted', flash[:notice]
  end

  # tenant tests

  test 'daisy cannot add a portion meal for john' do
    milk_portion = portions(:milk_default_portion)
    johns_journal_day = journal_days(:john_january_first)

    get new_my_journal_day_meal_path(johns_journal_day)
    follow_redirect!
    assert_response :success

    assert_equal 'That journal day does not exist or does not belong to you', flash[:warning]

    post my_journal_day_meals_path(johns_journal_day),
      params: {
        meal: {
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
    johns_meal = meals(:johns_apple_on_january_first)

    get edit_my_journal_day_meal_path(johns_meal.journal_day, johns_meal)
    follow_redirect!
    assert_response :success

    assert_equal 'That meal does not exist or does not belong to you', flash[:warning]

    patch my_journal_day_meal_path(johns_meal.journal_day, johns_meal),
      params: {
        meal: {
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
    johns_meal = meals(:johns_apple_on_january_first)
    delete my_journal_day_meal_path(johns_meal.journal_day, johns_meal)
    follow_redirect!
    assert_response :success
    assert_equal 'That meal does not exist or does not belong to you', flash[:warning]
  end
end
