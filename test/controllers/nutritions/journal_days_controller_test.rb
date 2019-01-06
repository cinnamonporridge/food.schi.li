require 'test_helper'

class Nutritions::JournalDaysControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_user(users(:john))
  end

  test '#index' do
    nutrition = nutritions(:apple)
    get nutrition_journal_days_path(nutrition)
    assert_response :success
  end
end
