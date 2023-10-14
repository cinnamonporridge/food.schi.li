require "test_helper"

class DayPartitionDecoratorTest < ActiveSupport::TestCase
  test ".day_partition_options_for_user" do
    DayPartitionDecorator.day_partition_options_for_user(users(:daisy)).tap do |options|
      assert_equal 3, options.count
      assert_equal "1 - Breakfast", options.first.first
      assert_equal "2 - Lunch", options.second.first
      assert_equal "3 - Afternoon", options.third.first
    end
  end

  test ".move_to_position_options_for_user" do
    DayPartitionDecorator.move_to_position_options_for_user(users(:daisy)).tap do |options|
      assert_equal 3, options.count
      assert_equal ["1 - Breakfast", 1], options.first
      assert_equal ["2 - Lunch", 2], options.second
      assert_equal ["3 - Afternoon", 3], options.third
    end
  end

  test "#display_name" do
    assert_equal "Unpartitioned", day_partitions(:daisy_default).decorate.display_name
    assert_equal "Breakfast", day_partitions(:daisy_breakfast).decorate.display_name
  end
end
