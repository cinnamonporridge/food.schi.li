require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'creates default day_portion on create' do
    user = User.new(email: 'foo@foo.bar', password: 'abc')

    assert_difference -> { DayPartition.count }, +1 do
      user.save!
    end

    user = User.last
    assert_equal 0, user.default_day_partition.position
  end
end
