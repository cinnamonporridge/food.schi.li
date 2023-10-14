require "test_helper"

class DayPartitionFormTest < ActiveSupport::TestCase
  test "#save, create valid" do
    user = users(:daisy)
    day_partition = user.day_partitions.new
    params = ActionController::Parameters.new(name: "Night", position: "-1")
    form = DayPartitionForm.new(day_partition, params)

    assert_difference -> { user.day_partitions.count }, +1 do
      assert form.save
    end
  end

  test "#save, create invalid" do
    user = users(:daisy)
    day_partition = user.day_partitions.new
    params = ActionController::Parameters.new(name: "", position: "-1")
    form = DayPartitionForm.new(day_partition, params)

    assert_not form.save
    assert_includes form.errors.to_a, "Name can't be blank"
  end

  test "#save, update valid" do
    day_partition = day_partitions(:daisy_breakfast)
    params = ActionController::Parameters.new(name: "Morning", position: day_partition.position)
    form = DayPartitionForm.new(day_partition, params)

    assert form.save
    assert_equal "Morning", day_partition.reload.name
  end

  test "#destroy" do
    user = users(:daisy)
    day_partition = day_partitions(:daisy_breakfast)
    form = DayPartitionForm.new(day_partition)

    assert_difference -> { user.day_partitions.count }, -1 do
      assert form.destroy
    end
  end
end
