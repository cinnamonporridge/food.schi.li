require 'test_helper'

class PortionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @global_food = foods(:banana)
    @global_food_portion = portions(:regular_banana_portion)
    @global_food_primary_portion = portions(:banana_default_portion)

    @daisy_food = foods(:milk)
    @daisy_food_portion = portions(:milk_tablespoon_portion)
    @daisy_food_primary_portion = portions(:milk_default_portion)
  end

  # new
  test 'get #new for own food' do
    sign_in_user :daisy
    get new_food_portion_path(@daisy_food)
    assert_response :success
  end

  test 'admin get #new for global food' do
    sign_in_user :daisy
    get new_food_portion_path(@global_food)
    assert_response :success
  end

  test 'non-admin cannot get #new for global food' do
    sign_in_user :john
    assert_not_get new_food_portion_path(@global_food)
  end

  test 'cannot get #new for other food' do
    sign_in_user :john
    assert_not_get new_food_portion_path(@daisy_food)
  end

  # create
  test 'post #create for own food' do
    sign_in_user :daisy

    assert_difference -> { @daisy_food.portions.count }, +1 do
      post food_portions_path(@daisy_food), params: {
        portion: {
          name: 'Small',
          amount: '56'
        }
      }
      follow_redirect!
      assert_response :success
      assert_notice 'Portion added'
    end

    @daisy_food.portions.last.tap do |portion|
      assert_equal 'Small', portion.name
      assert_in_delta(56.0, portion.amount)
      assert_equal 67, portion.kcal
      assert_in_delta(67.2, portion.carbs)
      assert_in_delta(6.72, portion.carbs_sugar_part)
      assert_in_delta(67.2, portion.protein)
      assert_in_delta(67.2, portion.fat)
      assert_in_delta(6.72, portion.fat_saturated)
      assert_in_delta(67.2, portion.fiber)
    end
  end

  test 'admin can post #create for global food' do
    sign_in_user :daisy

    assert_difference -> { @global_food.portions.count }, +1 do
      post food_portions_path(@global_food), params: {
        portion: {
          name: 'Small',
          amount: '61'
        }
      }
      follow_redirect!
      assert_response :success
      assert_notice 'Portion added'
    end

    @global_food.portions.last.tap do |portion|
      assert_equal 'Small', portion.name
      assert_in_delta(61.0, portion.amount)
      assert_equal 55, portion.kcal
      assert_in_delta(54.9, portion.carbs)
      assert_in_delta(5.49, portion.carbs_sugar_part)
      assert_in_delta(54.9, portion.protein)
      assert_in_delta(54.9, portion.fat)
      assert_in_delta(5.49, portion.fat_saturated)
      assert_in_delta(54.9, portion.fiber)
    end
  end

  test 'non-admin cannot post #create for global food' do
    sign_in_user :john
    assert_not_post food_portions_path(@global_food)
  end

  test 'cannot post #create for other' do
    sign_in_user :john
    assert_not_post food_portions_path(@daisy_food)
  end

  # edit
  test 'get #edit for own portion' do
    sign_in_user :daisy
    get edit_food_portion_path(@daisy_food, @daisy_food_portion)
    assert_response :success
  end

  test 'admin get #edit for global portion' do
    sign_in_user :daisy
    get edit_food_portion_path(@global_food, @global_food_portion)
    assert_response :success
  end

  test 'non-admin cannot get #edit for global portion' do
    sign_in_user :john
    assert_not_get edit_food_portion_path(@global_food, @global_food_portion)
  end

  test 'cannot get #edit of own primary' do
    sign_in_user :daisy
    assert_not_get edit_food_portion_path(@daisy_food, @daisy_food_primary_portion)
  end

  test 'admin cannot get #edit of global primary' do
    sign_in_user :daisy
    assert_not_get edit_food_portion_path(@global_food, @global_food_primary_portion)
  end

  test 'cannot get #edit of other' do
    sign_in_user :john
    assert_not_get edit_food_portion_path(@daisy_food, @daisy_food_portion)
  end

  # update
  test 'patch #update for own portion' do
    sign_in_user :daisy

    patch food_portion_path(@daisy_food, @daisy_food_portion), params: {
      portion: {
        name: 'Glass',
        amount: '180'
      }
    }
    follow_redirect!
    assert_response :success
    assert_notice 'Portion updated'

    @daisy_food_portion.reload.tap do |portion|
      assert_equal 'Glass', portion.name
      assert_equal 180, portion.amount
      assert_equal 216, portion.kcal
      assert_in_delta(216.0, portion.carbs)
      assert_in_delta(21.6, portion.carbs_sugar_part)
      assert_in_delta(216.0, portion.protein)
      assert_in_delta(216.0, portion.fat)
      assert_in_delta(21.6, portion.fat_saturated)
      assert_in_delta(216.0, portion.fiber)
    end
  end

  test 'admin can patch #update for global portion' do
    sign_in_user :daisy

    patch food_portion_path(@global_food, @global_food_portion), params: {
      portion: {
        name: 'Really big',
        amount: '200'
      }
    }
    follow_redirect!
    assert_response :success
    assert_notice 'Portion updated'

    @global_food_portion.reload.tap do |portion|
      assert_equal 'Really big', portion.name
      assert_equal 200, portion.amount
      assert_equal 180, portion.kcal
      assert_in_delta(180.0, portion.carbs)
      assert_in_delta(18.0, portion.carbs_sugar_part)
      assert_in_delta(180.0, portion.protein)
      assert_in_delta(180.0, portion.fat)
      assert_in_delta(18.0, portion.fat_saturated)
      assert_in_delta(180.0, portion.fiber)
    end
  end

  test 'non-admin cannot patch #update for global portion' do
    sign_in_user :john
    assert_not_patch food_portion_path(@global_food, @global_food_portion)
  end

  test 'cannot patch #update of own primary portion' do
    sign_in_user :daisy
    assert_not_patch food_portion_path(@daisy_food, @daisy_food_primary_portion)
  end

  test 'admin cannot patch #update for global primary portion' do
    sign_in_user :daisy
    assert_not_patch food_portion_path(@global_food, @global_food_primary_portion)
  end

  test 'cannot patch #update of other' do
    sign_in_user :john
    assert_not_patch food_portion_path(@global_food, @global_food_portion)
  end

  # destroy
  test 'delete #destroy of own portion' do
    sign_in_user :daisy

    portion = @daisy_food.portions.create!(name: 'Small', amount: 20)

    assert_difference -> { @daisy_food.portions.count }, -1 do
      delete food_portion_path(@daisy_food, portion)
      follow_redirect!
      assert_response :success
      assert_notice 'Portion deleted'
    end

    assert_raises ActiveRecord::RecordNotFound do
      portion.reload
    end
  end

  test 'admin can delete #destroy for global portion' do
    sign_in_user :daisy

    portion = @global_food.portions.create!(name: 'Small', amount: 20)

    assert_difference -> { @global_food.portions.count }, -1 do
      delete food_portion_path(@global_food, portion)
      follow_redirect!
      assert_response :success
      assert_notice 'Portion deleted'
    end

    assert_raises ActiveRecord::RecordNotFound do
      portion.reload
    end
  end

  test 'non-admin cannot delete #destroy for global portion' do
    sign_in_user :john
    assert_not_delete food_portion_path(@global_food, @global_food_portion)
  end

  test 'cannot delete #destroy of own primary' do
    sign_in_user :daisy
    assert_not_delete food_portion_path(@daisy_food, @daisy_food_primary_portion)
  end

  test 'admin cannot delete #destroy for global primary' do
    sign_in_user :daisy
    assert_not_delete food_portion_path(@global_food, @global_food_primary_portion)
  end

  test 'cannot delete #destroy of other' do
    sign_in_user :john
    assert_not_delete food_portion_path(@daisy_food, @daisy_food_portion)
  end

  test 'admin cannot delete #destroy of used global portion' do
    sign_in_user :daisy
    assert_not_delete food_portion_path(@global_food, @global_food_portion), error: ActiveRecord::DeleteRestrictionError
  end
end
