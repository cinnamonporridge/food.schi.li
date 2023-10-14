require "test_helper"

class DayPartition::SaveServiceTest < ActiveSupport::TestCase
  test "#save moves day partitions when inserting new to existing position" do
    user = users(:daisy)
    day_partition = DayPartition.new(user:, name: "Morning", position: 2)
    service = DayPartition::SaveService.new(day_partition)

    assert_ordered_day_partition_names(user, %w[Breakfast Lunch Afternoon])
    assert service.save
    assert_ordered_day_partition_names(user, %w[Breakfast Morning Lunch Afternoon])
  end

  test "#save insert to first position" do
    user = users(:daisy)
    day_partition = DayPartition.new(user:, name: "BeforeBreakfast", position: 1)
    service = DayPartition::SaveService.new(day_partition)

    assert_ordered_day_partition_names(user, %w[Breakfast Lunch Afternoon])
    assert service.save
    assert_ordered_day_partition_names(user, %w[BeforeBreakfast Breakfast Lunch Afternoon])
  end

  test "#save moves day partitions when updating to existing position" do
    user = users(:daisy)
    day_partition = day_partitions(:daisy_afternoon)
    day_partition.position = 1

    service = DayPartition::SaveService.new(day_partition)

    assert_ordered_day_partition_names(user, %w[Breakfast Lunch Afternoon])
    assert service.save
    assert_ordered_day_partition_names(user, %w[Afternoon Breakfast Lunch])
  end

  test "not #save default position and it already exists" do
    day_partition = day_partitions(:daisy_afternoon)
    day_partition.position = 0

    service = DayPartition::SaveService.new(day_partition)

    assert_not service.save

    assert_includes day_partition.errors.to_a, "Default day partition already exists"
  end

  test "#destroy normalizes day partitions after destroying" do
    user = users(:daisy)
    day_partition = day_partitions(:daisy_breakfast)
    service = DayPartition::SaveService.new(day_partition)

    assert_ordered_day_partition_names(user, %w[Breakfast Lunch Afternoon])
    assert service.destroy
    assert_ordered_day_partition_names(user, %w[Lunch Afternoon])
  end

  private

  def assert_ordered_day_partition_names(user, names)
    ordered_day_partition_names = user.day_partitions.not_defaults.ordered_by_position.pluck(:name)

    assert_equal names, ordered_day_partition_names
  end
end
