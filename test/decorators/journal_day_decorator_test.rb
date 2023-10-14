require "test_helper"

class JournalDayDecoratorTest < ActiveSupport::TestCase
  test "#display_date_with_weekday" do
    assert_equal "Wed, 01.02.2017", journal_days(:daisy_february_first).decorate.display_date_with_weekday
  end

  test "#display_weekday" do
    assert_equal "Wed", journal_days(:daisy_february_first).decorate.display_weekday
  end

  test "#display_date" do
    assert_equal "01.02.2017", journal_days(:daisy_february_first).decorate.display_date
  end

  test "#display_kcal" do
    assert_equal "301", journal_days(:daisy_february_first).decorate.display_kcal
  end

  test "#display_carbs" do
    assert_equal "301", journal_days(:daisy_february_first).decorate.display_carbs
  end

  test "#display_protein" do
    assert_equal "301", journal_days(:daisy_february_first).decorate.display_protein
  end

  test "#display_fat" do
    assert_equal "301", journal_days(:daisy_february_first).decorate.display_fat
  end
end
