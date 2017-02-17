require 'test_helper'

class ResetPasswordsControllerTest < ActionDispatch::IntegrationTest
  test 'should get reset password' do
    get reset_password_path(challenge: 'none')
    assert_response :success
  end

  test 'reset password with challenge' do
    john = reset_password(users(:john))
    post reset_passwords_path, params: reset_password_form_params('new', john.reset_password_challenge)
    follow_redirect!
    assert_response :success
    assert_equal 'Password successfully reset and logged in', flash[:success]

    john.reload
    assert_nil john.reset_password_challenge
    assert_nil john.reset_password_link_sent_at
  end

  test 'reset password with challenge and no new password' do
    john = reset_password(users(:john))
    post reset_passwords_path, params: reset_password_form_params('', john.reset_password_challenge)
    assert_response :success
    assert_equal 'Oops, something went wrong', flash[:warning]
  end

  test 'reset password with wrong challenge' do
    john = reset_password(users(:john))
    post reset_passwords_path, params: reset_password_form_params('new', 'wrongchallenge')
    assert_response :success
    assert_equal 'The provided challenge is not valid. Please reset your password again.', flash[:warning]
  end

  private

  def reset_password_form_params(password, challenge)
    {
      reset_password_form: {
        password: password,
        challenge: challenge
      }
    }
  end

  def reset_password(user)
    PasswordService.reset_link!(user)
    user.reload
  end
end
