ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def login_user(user, password = 'abc')
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

  def login_form_params(user_email, password)
    {
      login_form: { email: user_email, password: }
    }
  end
end
