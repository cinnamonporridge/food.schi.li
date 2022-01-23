require 'test_helper'

class JournalDayMealFormFinderServiceTest < ActiveSupport::TestCase
  test '#form, new portion form' do
    meal = Meal.new
    params = { meal_type: :portion }
    action = :new

    assert_equal Meals::Portions::Form, new_service(meal:, params:, action:).form.class
  end

  test '#form, edit portion form' do
    meal = meals(:daisys_big_apple_meal_on_february_first)
    params = { meal_type: :does_not_matter }
    action = :edit

    assert_equal Meals::Portions::Form, new_service(meal:, params:, action:).form.class
  end

  test '#form, new recipe form' do
    meal = Meal.new
    params = { meal_type: :recipe }
    action = :new

    assert_equal Meals::Recipes::NewForm, new_service(meal:, params:, action:).form.class
  end

  test '#form, edit recipe form' do
    meal = meals(:daisys_apple_pie_meal_on_february_fifth)
    params = { meal_type: :does_not_matter }
    action = :edit

    assert_equal Meals::Recipes::EditForm, new_service(meal:, params:, action:).form.class
  end

  private

  def new_service(meal:, params:, action:)
    JournalDayMealFormFinderService.new(meal, params, action)
  end
end
