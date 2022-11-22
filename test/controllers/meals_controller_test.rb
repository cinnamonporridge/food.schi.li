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
    sign_in_user :daisy
    get new_journal_day_meal_path(@journal_day, meal_type: :portion)

    assert_response :success
  end

  test 'get #new, meal_type: :recipe' do
    sign_in_user :daisy
    get new_journal_day_meal_path(@journal_day, meal_type: :recipe)

    assert_response :success
  end

  test 'cannot get #new, meal_type: :unknown' do
    sign_in_user :daisy

    assert_not_get(
      new_journal_day_meal_path(@journal_day, meal_type: :unknown),
      error: JournalDayMealFormFinderService::FormClassNotFound
    )
  end

  test 'cannot get #new of other' do
    sign_in_user :john

    assert_not_get new_journal_day_meal_path(@journal_day, meal_type: :portion)
  end

  # create
  test 'post #create, meal_type: :portion' do # rubocop:disable Metrics/BlockLength
    sign_in_user :daisy

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
      assert_notice 'Meal added'
    end

    @journal_day.meals.last.tap do |meal|
      assert_equal 'Portion', meal.consumable_type
      assert_equal @day_partition, meal.day_partition

      meal.meal_ingredients.first.tap do |meal_ingredient|
        assert_equal portions(:sugar_cube_portion), meal_ingredient.portion
        assert_equal 75, meal_ingredient.amount
        assert_equal 'piece', meal_ingredient.measure
        assert_equal 250, meal_ingredient.kcal
        assert_in_delta(249.75, meal_ingredient.carbs)
        assert_in_delta(24.75, meal_ingredient.carbs_sugar_part)
        assert_in_delta(249.75, meal_ingredient.protein)
        assert_in_delta(249.75, meal_ingredient.fat)
        assert_in_delta(24.75, meal_ingredient.fat_saturated)
        assert_in_delta(249.75, meal_ingredient.fiber)
      end
    end
  end

  test 'post #create, meal_type: :recipe' do
    sign_in_user :daisy

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
      assert_notice 'Meal added'
    end

    @journal_day.meals.last.tap do |meal|
      assert_equal 'Recipe', meal.consumable_type
      assert_equal @day_partition, meal.day_partition
      assert_equal 2, meal.meal_ingredients.count
    end
  end

  test 'cannot post #create, meal_type: :unknown' do
    sign_in_user :daisy

    assert_raises JournalDayMealFormFinderService::FormClassNotFound do
      post journal_day_meals_path(@journal_day), params: { meal_type: :unknown }
    end
  end

  test 'cannot get #post of other' do
    sign_in_user :john

    assert_not_post(journal_day_meals_path(@journal_day))
  end

  # edit
  test 'get #edit, portion meal' do
    sign_in_user :daisy
    get edit_journal_day_meal_path(@journal_day, @portion_meal)

    assert_response :success
  end

  test 'get #edit, recipe meal' do
    sign_in_user :daisy
    get edit_journal_day_meal_path(@journal_day, @recipe_meal)

    assert_response :success
  end

  test 'cannot get #edit of other, portion meal' do
    sign_in_user :john

    assert_not_get edit_journal_day_meal_path(@journal_day, @portion_meal)
  end

  test 'cannot get #edit of other, recipe meal' do
    sign_in_user :john

    assert_not_get edit_journal_day_meal_path(@journal_day, @recipe_meal)
  end

  # update
  test 'patch #update, portion meal' do # rubocop:disable Metrics/BlockLength
    sign_in_user :daisy

    patch journal_day_meal_path(@journal_day, @portion_meal), params: {
      journal_day_meal: {
        portion_name: 'Apple Big Apple (200g)',
        amount_in_measure: '2',
        measure: 'piece',
        day_partition_id: @day_partition.id
      }
    }
    follow_redirect!

    assert_response :success
    assert_notice 'Meal updated'

    @portion_meal.reload

    assert_equal @day_partition, @portion_meal.day_partition

    @portion_meal.meal_ingredients.first.tap do |meal_ingredient|
      assert_equal portions(:big_apple_portion), meal_ingredient.portion
      assert_equal 400, meal_ingredient.amount
      assert_equal 'piece', meal_ingredient.measure
      assert_equal 400, meal_ingredient.kcal
      assert_in_delta(400.0, meal_ingredient.carbs)
      assert_in_delta(40.0, meal_ingredient.carbs_sugar_part)
      assert_in_delta(400.0, meal_ingredient.protein)
      assert_in_delta(400.0, meal_ingredient.fat)
      assert_in_delta(40.0, meal_ingredient.fat_saturated)
      assert_in_delta(400.0, meal_ingredient.fiber)
    end
  end

  test 'patch #update, recipe meal' do
    sign_in_user :daisy

    patch journal_day_meal_path(@journal_day, @recipe_meal), params: {
      journal_day_meal: {
        day_partition_id: @day_partition.id
      }
    }
    follow_redirect!

    assert_response :success
    assert_notice 'Meal updated'

    @recipe_meal.reload

    assert_equal @day_partition, @recipe_meal.day_partition
  end

  test 'cannot patch #update of other, portion meal' do
    sign_in_user :john

    assert_not_patch(journal_day_meal_path(@journal_day, @portion_meal))
  end

  test 'cannot patch #update of other, recipe meal' do
    sign_in_user :john

    assert_not_patch(journal_day_meal_path(@journal_day, @recipe_meal))
  end

  # destroy
  test 'delete #destroy' do
    sign_in_user :daisy

    assert_difference -> { @journal_day.meals.count }, -1 do
      delete journal_day_meal_path(@journal_day, @portion_meal)
      follow_redirect!

      assert_response :success
      assert_notice 'Meal deleted'
    end

    assert_raises ActiveRecord::RecordNotFound do
      @portion_meal.reload
    end
  end

  test 'cannot delete #destroy of other' do
    sign_in_user :john

    assert_not_delete journal_day_meal_path(@journal_day, @portion_meal)
  end
end
