ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def login_user(fixture_key, password = 'abc')
    user = users(fixture_key)
    post login_url, params: login_form_params(user.email, password)
    follow_redirect!
  end

  def logout_user
    delete logout_path
    follow_redirect!
  end

  def last_email
    ActionMailer::Base.deliveries.last
  end

  private

  def assert_notice(message)
    assert_equal flash[:notice], message
  end

  def assert_not_get(path, error: ActiveRecord::RecordNotFound)
    assert_raises(error) { get path }
  end

  def assert_not_post(path, params: {}, error: ActiveRecord::RecordNotFound)
    assert_raises(error) do
      post(path, params:)
    end
  end

  def assert_not_patch(path, params: {}, error: ActiveRecord::RecordNotFound)
    assert_raises(error) do
      patch(path, params:)
    end
  end

  def assert_not_delete(path, error: ActiveRecord::RecordNotFound)
    assert_raises(error) { delete path }
  end

  def login_form_params(user_email, password)
    {
      login_form: { email: user_email, password: }
    }
  end
end
