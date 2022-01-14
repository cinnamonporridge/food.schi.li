require 'test_helper'

class Foods::JournalDaysControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_user :daisy
  end

  test '#index' do
    food = foods(:apple)
    get food_journal_days_path(food)
    assert_response :success
  end
end
