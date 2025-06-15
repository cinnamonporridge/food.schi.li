ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
require "rails/test_help"

Dir["./test/test_helpers/*.rb"].each { require _1 }

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  parallelize(workers: :number_of_processors)

  def sign_in_user(fixture_key, password = "abc")
    user = users(fixture_key)
    post login_url, params: login_form_params(user.email, password)
    follow_redirect!
  end

  def sign_out
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

  def assert_not_get(path)
    get path
    assert_response :not_found
  end

  def assert_not_post(path)
    post path
    assert_response :not_found
  end

  def assert_not_patch(path)
    patch path
    assert_response :not_found
  end

  def assert_not_delete(path)
    delete path
    assert_response :not_found
  end

  def login_form_params(user_email, password)
    {
      login_form: { email: user_email, password: }
    }
  end

  def new_object(...)
    self.class.name.sub(/Test$/, "").constantize.new(...)
  end
end

class ViewComponent::TestCase
  def new_component(...)
    self.class.name.sub(/Test$/, "").constantize.new(...)
  end
end
