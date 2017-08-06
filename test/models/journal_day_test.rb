require 'test_helper'

class JournalDayTest < ActiveSupport::TestCase
  test 'of scope' do
    assert_includes JournalDay.of(users(:daisy)), journal_days(:daisy_february_first)
    assert_not_includes JournalDay.of(users(:daisy)), journal_days(:john_january_first)
    assert_includes JournalDay.of(users(:john)), journal_days(:john_january_first)
    assert_empty JournalDay.of
  end
end
