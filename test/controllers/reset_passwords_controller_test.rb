require 'test_helper'

class ResetPasswordsControllerTest < ActionDispatch::IntegrationTest
  test 'should get reset password' do
    get reset_password_path(challenge: 'none')
    assert_response :success
  end

  test 'reset password with challenge' do
    john = users(:john)
    PasswordService.reset!(john)
    john.reload
    post reset_passwords_path, params: reset_password_form_params(john.reset_password_challenge)
    follow_redirect!
    assert_response :success
    assert_equal 'Password successfully reset and logged in', flash[:success]
  end

  private

  def reset_password_form_params(challenge)
    {
      reset_password_form: {
        password: 'new',
        challenge: challenge
      }
    }
  end
end
