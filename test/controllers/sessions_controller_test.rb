require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    get login_url
    assert_response :success
  end

  test 'login fails with missing email' do
    post login_url, params: login_form_params_missing_email
    assert_response :success
    assert_equal 'Oops, something went wrong', flash[:warning]
  end

  test 'login fails with missing password' do
    post login_url, params: login_form_params_missing_password
    assert_response :success
    assert_equal 'Oops, something went wrong', flash[:warning]
  end

  test 'successful login and logout' do
    login_user(users(:john))
    assert_response :success
    logout_user
    assert_response :success
  end

  test 'invalid login credentials' do
    post login_url, params: login_form_wrong_params
    assert_response :success
    assert_equal 'Invalid email or password', flash[:warning]
  end

  private

  def login_form_wrong_params
    {
      login_form: { email: 'john@foo.bar', password: 'xxx' }
    }
  end

  def login_form_params_missing_email
    {
      login_form: { email: '', password: 'abc' }
    }
  end

  def login_form_params_missing_password
    {
      login_form: { email: 'john@foo.bar', password: '' }
    }
  end
end
