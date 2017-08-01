require 'test_helper'

class JournalDayFlowTest < ActionDispatch::IntegrationTest

  def setup
    login_user(users(:daisy))
  end

  test 'user visits journal days index page' do
    get '/my/journal_days'
    assert_response :success

    assert_select 'h1', 'My journal days'
    assert_select 'ul.journal-days-list-group li', 2, 'Daisy has 2 journal days'
    assert_select 'a.primary.button', 'Add Journal Day'
  end

  test 'user visits own journal day' do
    get "/my/journal_days/#{journal_days(:daisy_february_first).id}"
    assert_response :success

    assert_select 'h1', 'Wednesday, 01.02.2017'
    assert_select 'a.warning.button', 'Edit'
    assert_select 'a.alert.button', 'Delete'
  end

  test 'daisy cannot visit johns journal day' do
    get "/my/journal_days/#{journal_days(:john_january_first).id}"
    follow_redirect!
    assert_response :success
    assert_equal 'That journal day does not exist or does not belong to you', flash[:warning]
    assert_select 'h1', 'My journal days'
  end
end
