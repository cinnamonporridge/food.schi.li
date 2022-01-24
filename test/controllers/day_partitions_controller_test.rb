require 'test_helper'

class DayPartitionsControllerTest < ActionDispatch::IntegrationTest
  test 'get index' do
    login_user :daisy
    get day_partitions_path
    assert_response :success
  end

  # new
  test 'get new' do
    login_user :daisy
    get new_day_partition_path
    assert_response :success
  end

  # create
  test 'post create' do
    user = users(:daisy)
    login_user :daisy

    assert_difference -> { user.day_partitions.count }, +1 do
      post day_partitions_path, params: {
        day_partition: {
          name: 'Night',
          position: '-1'
        }
      }
    end
    follow_redirect!
    assert_response :success

    day_partition = user.day_partitions.last
    assert_equal 'Night', day_partition.name
    assert_equal 4, day_partition.position
  end

  # edit
  test 'get edit' do
    login_user :daisy
    get edit_day_partition_path(day_partitions(:daisy_breakfast))
    assert_response :success
  end

  test 'cannot get edit default' do
    login_user :daisy
    assert_raises ActiveRecord::RecordNotFound do
      get edit_day_partition_path(day_partitions(:daisy_default))
    end
  end

  test 'cannot get edit of other' do
    login_user :daisy

    assert_raises ActiveRecord::RecordNotFound do
      get edit_day_partition_path(day_partitions(:john_brunch))
    end
  end

  # update
  test 'put update' do
    login_user :daisy

    day_partition = day_partitions(:daisy_breakfast)

    assert_changes -> { day_partition.name }, to: 'Morning' do
      patch day_partition_path(day_partition), params: {
        day_partition: {
          name: 'Morning'
        }
      }
      day_partition.reload
    end
    follow_redirect!
    assert_response :success
  end

  test 'cannot put update default' do
    login_user :daisy
    assert_raises ActiveRecord::RecordNotFound do
      patch day_partition_path(day_partitions(:daisy_default)), params: {}
    end
  end

  test 'cannot put update of other' do
    login_user :daisy

    day_partition = day_partitions(:john_brunch)

    assert_raises ActiveRecord::RecordNotFound do
      patch day_partition_path(day_partition), params: {}
    end
  end

  # destroy
  test 'delete destroy' do
    user = users(:daisy)
    login_user :daisy

    day_partition = day_partitions(:daisy_breakfast)

    assert_difference -> { user.day_partitions.count }, -1 do
      delete day_partition_path(day_partition), params: {}
    end
  end

  test 'cannot delete destroy default' do
    login_user :daisy
    assert_raises ActiveRecord::RecordNotFound do
      delete day_partition_path(day_partitions(:daisy_default))
    end
  end

  test 'cannot delete destroy of other' do
    login_user :daisy

    day_partition = day_partitions(:john_brunch)

    assert_raises ActiveRecord::RecordNotFound do
      delete day_partition_path(day_partition), params: {}
    end
  end
end
