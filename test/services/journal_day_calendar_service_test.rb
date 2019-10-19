require 'test_helper'

class JournalDayCalendarServiceTest < ActiveSupport::TestCase
  setup do
    @daisy = users(:daisy)
    @february_first = journal_days(:daisy_february_first)
    @february_second = journal_days(:daisy_february_second)
    @february_fourth = journal_days(:daisy_february_fourth)

    # pre-condition
    assert_not @daisy.journal_days.find_by(date: Date.new(2017, 2, 3)).present?,
               'February third may not exist for Daisy'
  end

  test 'next existing journal day' do
    service = JournalDayCalendarService.new(@february_second)
    assert_equal @february_fourth, service.next_journal_day

    service = JournalDayCalendarService.new(@february_fourth)
    assert_nil service.next_journal_day
  end

  test 'previous existing journal day' do
    service = JournalDayCalendarService.new(@february_second)
    assert_equal @february_first, service.previous_journal_day

    service = JournalDayCalendarService.new(@february_first)
    assert_nil service.previous_journal_day
  end
end
