require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "creates default day_portion on create" do
    user = User.new(email: "foo@foo.bar", password: "abc")

    assert_difference -> { DayPartition.count }, +1 do
      user.save!
    end

    user = User.last

    assert_equal 0, user.default_day_partition.position
  end

  test ".find_global_user" do
    user = User.find_global_user

    assert_equal users(:global), user
  end

  test "#global_user?" do
    assert_predicate users(:global), :global_user?
    assert_not users(:daisy).global_user?
  end

  test "default role" do
    assert_equal "user", User.new.role
  end

  test "validates locale" do
    user = users(:daisy)
    user.locale = :invalid

    assert_not user.valid?
    assert_includes user.errors.to_a, "Language is not included in the list"
  end
end
