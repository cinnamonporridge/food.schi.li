require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get login_url

    assert_response :success
  end

  test "login fails with missing email" do
    post login_url, params: login_form_params_missing_email

    assert_response :success
    assert_equal "Oops, something went wrong", flash[:notice]
  end

  test "login fails with missing password" do
    post login_url, params: login_form_params_missing_password

    assert_response :success
    assert_equal "Oops, something went wrong", flash[:notice]
  end

  test "successful login and logout" do
    sign_in_user :john

    assert_response :success
    sign_out

    assert_response :success
  end

  test "invalid login credentials" do
    post login_url, params: login_form_wrong_params

    assert_response :success
    assert_equal "Invalid email or password", flash[:notice]
  end

  test "cannot login as global user" do
    post login_url, params: { login_form: { email: GlobalUser::GLOBAL_USER_EMAIL, password: "abc" } }

    assert_response :success
    assert_equal "Invalid email or password", flash[:notice]
  end

  private

  def login_form_wrong_params
    {
      login_form: { email: "john@foo.bar", password: "xxx" }
    }
  end

  def login_form_params_missing_email
    {
      login_form: { email: "", password: "abc" }
    }
  end

  def login_form_params_missing_password
    {
      login_form: { email: "john@foo.bar", password: "" }
    }
  end
end
