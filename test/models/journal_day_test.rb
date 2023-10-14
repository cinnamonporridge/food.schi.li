require "test_helper"

class JournalDayTest < ActiveSupport::TestCase
  test ".of_user_user" do
    assert_includes JournalDay.of_user(users(:daisy)), journal_days(:daisy_february_first)
    assert_not_includes JournalDay.of_user(users(:daisy)), journal_days(:john_january_first)
    assert_includes JournalDay.of_user(users(:john)), journal_days(:john_january_first)
    assert_empty JournalDay.of_user
  end
end
