require 'test_helper'

class MealsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:daisy)
    @journal_day = journal_days(:daisy_february_first)
    @portion_meal = meals(:daisys_big_apple_meal_on_february_first)
    @recipe_meal = meals(:daisys_apple_pie_meal_on_february_fifth)
    @day_partition = day_partitions(:daisy_afternoon)
  end

  # show
  test 'get #new, meal_type: :portion' do
    login_user :daisy
    get new_journal_day_meal_path(@journal_day, meal_type: :portion)
    assert_response :success
  end

  test 'get #new, meal_type: :recipe' do
    login_user :daisy
    get new_journal_day_meal_path(@journal_day, meal_type: :recipe)
    assert_response :success
  end

  test 'cannot get #new, meal_type: :unknown' do
    login_user :daisy
    assert_not_get(
      new_journal_day_meal_path(@journal_day, meal_type: :unknown),
      error: JournalDayMealFormFinderService::FormClassNotFound
    )
  end

  test 'cannot get #new of other' do
    login_user :john
    assert_not_get new_journal_day_meal_path(@journal_day, meal_type: :portion)
  end

  # create
  test 'post #create, meal_type: :portion' do
    login_user :daisy

    assert_difference -> { @journal_day.meals.count }, +1 do
      post journal_day_meals_path(@journal_day), params: {
        meal_type: :portion,
        journal_day_meal: {
          portion_name: 'Sugar Cube (25g)',
          amount_in_measure: '3',
          measure: 'piece',
          day_partition_id: @day_partition.id
        }
      }
      follow_redirect!
      assert_response :success
      assert_notice 'Portion added'
    end

    @journal_day.meals.last.tap do |meal|
      assert_equal 'Portion', meal.consumable_type
      assert_equal @day_partition, meal.day_partition

      meal.meal_ingredients.first.tap do |meal_ingredient|
        assert_equal 'Sugar Cube (25g)', meal_ingredient.portion.decorate.name_for_dropdown
        assert_equal 250, meal_ingredient.kcal
        assert_equal 249.75, meal_ingredient.carbs
        assert_equal 24.75, meal_ingredient.carbs_sugar_part
        assert_equal 249.75, meal_ingredient.protein
        assert_equal 249.75, meal_ingredient.fat
        assert_equal 24.75, meal_ingredient.fat_saturated
        assert_equal 249.75, meal_ingredient.fiber
      end
    end
  end

  test 'post #create, meal_type: :recipe' do
    login_user :daisy

    assert_difference -> { @journal_day.meals.count }, +1 do
      post journal_day_meals_path(@journal_day), params: {
        meal_type: :recipe,
        journal_day_meal: {
          recipe_name: 'Apple Pie (6 servings)',
          servings: '3',
          day_partition_id: @day_partition.id
        }
      }
      follow_redirect!
      assert_response :success
      assert_notice 'Portion added'
    end

    @journal_day.meals.last.tap do |meal|
      assert_equal 'Recipe', meal.consumable_type
      assert_equal @day_partition, meal.day_partition
      assert_equal 2, meal.meal_ingredients.count
    end
  end

  test 'cannot post #create, meal_type: :unknown' do
    login_user :daisy

    assert_not_post(
      journal_day_meals_path(@journal_day),
      params: { meal_type: :unknown },
      error: JournalDayMealFormFinderService::FormClassNotFound
    )
  end

  test 'cannot get #post of other' do
    assert false, 'todo'
  end

  # edit
  test 'get #edit, portion meal' do
    assert false, 'todo'
  end

  test 'get #edit, recipe meal' do
    assert false, 'todo'
  end

  test 'cannot get #edit of other' do
    assert false, 'todo'
  end

  # update
  test 'patch #update, portion meal' do
    assert false, 'todo'
  end

  test 'patch #update, recipe meal' do
    assert false, 'todo'
  end

  test 'cannot patch #update of other' do
    assert false, 'todo'
  end

  # destroy
  test 'delete #destroy' do
    assert false, 'todo'
  end

  test 'cannot delete #destroy of other' do
    assert false, 'todo'
  end
end
