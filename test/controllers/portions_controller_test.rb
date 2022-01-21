require 'test_helper'

class PortionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @food = foods(:banana)
    @portion = portions(:regular_banana_portion)
    @primary_portion = portions(:banana_default_portion)
  end

  # new
  test 'get #new' do
    login_user :daisy
    get new_food_portion_path(@food)
    assert_response :success
  end

  test 'cannot get #new for other' do
    login_user :john
    assert_raises ActiveRecord::RecordNotFound do
      get new_food_portion_path(@food)
    end
  end

  # create
  test 'post #create' do
    login_user :daisy

    assert_difference -> { @food.portions.count }, +1 do
      post food_portions_path(@food), params: {
        portion: {
          name: 'Small',
          amount: '56'
        }
      }
      follow_redirect!
      assert_response :success
      assert_notice 'Portion added'
    end

    @food.portions.last.tap do |portion|
      assert_equal 'Small', portion.name
      assert_equal 56.0, portion.amount
      assert_equal 50, portion.kcal
      assert_equal 50.4, portion.carbs
      assert_equal 5.04, portion.carbs_sugar_part
      assert_equal 50.4, portion.protein
      assert_equal 50.4, portion.fat
      assert_equal 5.04, portion.fat_saturated
      assert_equal 50.4, portion.fiber
    end
  end

  test 'cannot post #create for other' do
    login_user :john
    assert_raises ActiveRecord::RecordNotFound do
      post food_portions_path(@food), params: {}
    end
  end

  # edit
  test 'get #edit' do
    login_user :daisy
    get edit_food_portion_path(@food, @portion)
    assert_response :success
  end

  test 'cannot get #edit of primary' do
    login_user :daisy
    assert_raises ActiveRecord::RecordNotFound do
      get edit_food_portion_path(@food, @primary_portion)
    end
  end

  test 'cannot get #edit of other' do
    login_user :john
    assert_raises ActiveRecord::RecordNotFound do
      get edit_food_portion_path(@food, @portion)
    end
  end

  # update
  test 'patch #update' do
    login_user :daisy

    patch food_portion_path(@food, @portion), params: {
      portion: {
        name: 'Really big',
        amount: '200'
      }
    }
    follow_redirect!
    assert_response :success
    assert_notice 'Portion updated'

    @portion.reload
    assert_equal 'Really big', @portion.name
    assert_equal 200, @portion.amount
    assert_equal 180, @portion.kcal
    assert_equal 180.0, @portion.carbs
    assert_equal 18.0, @portion.carbs_sugar_part
    assert_equal 180.0, @portion.protein
    assert_equal 180.0, @portion.fat
    assert_equal 18.0, @portion.fat_saturated
    assert_equal 180.0, @portion.fiber
  end

  test 'cannot patch #update of primary' do
    login_user :daisy
    assert_raises ActiveRecord::RecordNotFound do
      patch food_portion_path(@food, @primary_portion)
    end
  end

  test 'cannot patch #update of other' do
    login_user :john
    assert_raises ActiveRecord::RecordNotFound do
      patch food_portion_path(@food, @portion), params: {}
    end
  end

  # destroy
  test 'delete #destroy' do
    login_user :daisy

    portion = @food.portions.create!(name: 'Small', amount: 20)

    assert_difference -> { @food.portions.count }, -1 do
      delete food_portion_path(@food, portion)
      follow_redirect!
      assert_response :success
      assert_notice 'Portion deleted'
    end

    assert_raises ActiveRecord::RecordNotFound do
      portion.reload
    end
  end

  test 'cannot delete #destroy of primary' do
    login_user :daisy
    assert_raises ActiveRecord::RecordNotFound do
      delete food_portion_path(@food, @primary_portion)
    end
  end

  test 'cannot delete #destroy of other' do
    login_user :john
    assert_raises ActiveRecord::RecordNotFound do
      delete food_portion_path(@food, @portion)
    end
  end
end
