require 'test_helper'

class JournalDaysControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_user :daisy
  end

  # index
  test 'get index' do
    get journal_days_path
    assert_response :success
  end

  # show
  test 'get show' do
    get journal_day_path(journal_days(:daisy_february_first))
    assert_response :success
  end

  test 'cannot get show of other' do
    assert_raises ActiveRecord::RecordNotFound do
      get journal_day_path(journal_days(:john_january_first))
    end
  end

  # new
  test 'get new' do
    get new_journal_day_path
    assert_response :success
  end

  # create
  test 'post create' do
    user = users(:daisy)

    assert_difference -> { user.journal_days.count }, +1 do
      post journal_days_path, params: {
        journal_day: {
          date: '2017-02-06'
        }
      }
    end
    follow_redirect!
    assert_response :success

    journal_day = user.journal_days.last
    assert_equal Date.new(2017, 2, 6), journal_day.date

    assert_equal 'Journal day added', flash[:notice]
  end

  # edit
  test 'get edit' do
    get edit_journal_day_path(journal_days(:daisy_february_first))
    assert_response :success
  end

  test 'cannot get edit of other' do
    assert_raises ActiveRecord::RecordNotFound do
      get edit_journal_day_path(journal_days(:john_january_first))
    end
  end

  # update
  test 'patch update' do
    journal_day = journal_days(:daisy_february_first)

    assert_changes -> { journal_day.date }, to: Date.new(2017, 1, 31) do
      patch journal_day_path(journal_day), params: {
        journal_day: {
          date: '2017-01-31'
        }
      }
      journal_day.reload
    end
    follow_redirect!
    assert_response :success

    assert_equal Date.new(2017, 1, 31), journal_day.date
    assert_equal 'Journal day updated', flash[:notice]
  end

  test 'cannot patch update of other' do
    assert_raises ActiveRecord::RecordNotFound do
      patch journal_day_path(journal_days(:john_january_first)), params: {}
    end
  end

  # destroy
  test 'delete destroy' do
    user = users(:daisy)

    assert_difference -> { user.journal_days.count }, -1 do
      delete journal_day_path(journal_days(:daisy_february_first))
    end
    follow_redirect!
    assert_response :success

    assert_equal 'Journal day deleted', flash[:notice]
  end

  test 'cannot delete destroy of other' do
    assert_raises ActiveRecord::RecordNotFound do
      delete journal_day_path(journal_days(:john_january_first))
    end
  end
end
