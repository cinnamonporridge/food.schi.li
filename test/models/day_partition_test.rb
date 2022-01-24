require 'test_helper'

class DayPartitionTest < ActiveSupport::TestCase
  test 'validates' do
    day_partition = DayPartition.new
    assert_not day_partition.save

    errors = day_partition.errors.to_a
    assert_equal 3, errors.count
    assert_includes errors, 'User must exist'
    assert_includes errors, "Name can't be blank"
    assert_includes errors, 'Position must be greater than or equal to 0'
  end

  test 'save' do
    assert DayPartition.new(user: users(:daisy), name: 'Something').save
  end
end
