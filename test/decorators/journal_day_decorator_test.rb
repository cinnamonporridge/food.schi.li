require 'test_helper'

class JournalDayDecoratorTest < Draper::TestCase
  test 'display date' do
    journal_day = journal_days(:daisy_february_first)
    assert_equal 'Wed, 01.02.2017', journal_day.decorate.display_date_with_weekday
    assert_equal '01.02.2017', journal_day.decorate.display_date
  end
end
