require 'test_helper'

class ForgotPasswordsControllerTest < ActionDispatch::IntegrationTest
  test 'should get forgot passwords' do
    get new_forgot_passwords_path
    assert_response :success
  end

  test 'reset password' do
    post forgot_passwords_path, params: reset_password_form_params
    follow_redirect!
    assert_response :success
    assert_equal 'A reset link has been sent to your email address', flash[:success]
    assert_equal 'Your password reset link', last_email.subject
  end

  test 'missing email for reset' do
    post forgot_passwords_path, params: reset_password_form_params_missing_email
    assert_response :success
    assert_equal 'Oops, something went wrong', flash[:warning]
  end

  test 'missing email for magic link' do
    post forgot_passwords_path, params: magic_link_form_params_missing_email
    assert_response :success
    assert_equal 'Oops, something went wrong', flash[:warning]
  end

  private

  def reset_password_form_params
    {
      forgot_password_form: {
        email: 'john@foo.bar'
      },
      reset: 'Reset my password'
    }
  end

  def reset_password_form_params_missing_email
    {
      forgot_password_form: {
        email: ''
      },
      reset: 'Reset my password'
    }
  end

  def magic_link_form_params
    {
      forgot_password_form: {
        email: 'john@foo.bar'
      },
      magic_link: 'Send me a magic link'
    }
  end

  def magic_link_form_params_missing_email
    {
      forgot_password_form: {
        email: ''
      },
      magic_link: 'Send me a magic link'
    }
  end
end
