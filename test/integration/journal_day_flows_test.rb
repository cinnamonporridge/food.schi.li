require 'test_helper'

class JournalDayFlowTest < ActionDispatch::IntegrationTest

  def setup
    login_user(users(:daisy))
  end

  test 'daisy visits journal days index page' do
    get '/my/journal_days'
    assert_response :success

    assert_select 'h1', 'My journal days'
    assert_select 'ul.journal-days-list-group li', users(:daisy).journal_days.count
    assert_select 'a.primary.button', 'Add Journal Day'
  end

  test 'daisy visits own journal day' do
    get "/my/journal_days/#{journal_days(:daisy_february_first).id}"
    assert_response :success

    assert_select 'h1', 'Wednesday, 01.02.2017'
    assert_select 'h2', 'Meals'
    assert_select 'h2', 'Nutritions'
    assert_select 'a.warning.button', 'Edit'
    assert_select 'a.alert.button', 'Delete'

    expected_meal_buttons = ['Add portion meal', 'Add recipe meal']

    css_select('a.primary.button').each_with_index do |link, i|
      assert_equal expected_meal_buttons[i], link.text
    end
  end

  test 'daisy adds a new journal day' do
    get '/my/journal_days/new'
    assert_response :success

    assert_select 'h1', 'Add Journal Day'
    assert_select "input[type='submit'][value='Create Journal day']"
    assert_select 'a.secondary.button', 'Cancel'

    post '/my/journal_days/',
      params: {
        journal_day: {
          date: '02.02.2222'
        }
      }
    follow_redirect!
    assert_response :success
  end

  test 'daisy edits page of own journal day' do
    get "/my/journal_days/#{journal_days(:daisy_february_first).id}/edit"
    assert_response :success

    assert_select 'h1', 'Edit Wednesday, 01.02.2017'
    assert_select "input[type='submit'][value='Update Journal day']"
    assert_select 'a.secondary.button', 'Cancel'

    patch "/my/journal_days/#{journal_days(:daisy_february_first).id}/",
      params: {
        journal_day: {
          date: '02.02.2222'
        }
      }
    follow_redirect!
    assert_response :success
  end

  test 'daisy tries to add a journal day that already exists' do
    patch "/my/journal_days/#{journal_days(:daisy_february_first).id}/",
      params: {
        journal_day: {
          date: '02.02.2017'
        }
      }
    assert_response :success

    assert_equal 'Invalid input', flash[:error]
  end

  test 'daisy deletes a journal day' do
    delete "/my/journal_days/#{journal_days(:daisy_february_first).id}/"
    follow_redirect!
    assert_response :success
    assert_select 'h1', 'My journal days'
    assert_equal 'Journal day deleted', flash[:notice]
  end

  # tenant tests

  test 'daisy cannot visit johns journal day' do
    get "/my/journal_days/#{journal_days(:john_january_first).id}"
    follow_redirect!
    assert_response :success
    assert_equal 'That journal day does not exist or does not belong to you', flash[:warning]
    assert_select 'h1', 'My journal days'
  end

  test 'daisy cannot edit johns journal day' do
    get "/my/journal_days/#{journal_days(:john_january_first).id}/edit"
    follow_redirect!
    assert_response :success
    assert_equal 'That journal day does not exist or does not belong to you', flash[:warning]
    assert_select 'h1', 'My journal days'

    patch "/my/journal_days/#{journal_days(:john_january_first).id}/",
      params: {
        journal_day: {
          date: '02.02.2222'
        }
      }
    follow_redirect!
    assert_response :success
    assert_equal 'That journal day does not exist or does not belong to you', flash[:warning]
    assert_select 'h1', 'My journal days'
  end

  test 'daisy cannot delete johns journal day' do
    delete "/my/journal_days/#{journal_days(:john_january_first).id}/"
    follow_redirect!
    assert_response :success
    assert_equal 'That journal day does not exist or does not belong to you', flash[:warning]
    assert_select 'h1', 'My journal days'
  end
end
