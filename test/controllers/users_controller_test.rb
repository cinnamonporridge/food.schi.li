require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'logged in admin should get index' do
    daisy = login_user(users(:daisy))
    get users_path
    assert_response :success
  end

  test 'logged in other user should not get index' do
    john = login_user(users(:john))
    get users_path
    follow_redirect!
    assert_response :success
  end

  test 'not logged in user should not get index' do
    get users_path
    follow_redirect!
    assert_response :success
  end

  test 'admin can show user' do
    daisy = login_user(users(:daisy))
    get users_path(users(:john))
    assert_response :success
  end

  test 'admin can get new user' do
    daisy = login_user(users(:daisy))
    get new_user_path
    assert_response :success
  end

  test 'admin can invite new people' do
    daisy = login_user(users(:daisy))
    post users_path, params: user_params
    assert_response :success
    assert_equal 'Invitation has been sent', flash[:success]
  end

  test 'admin is informed about missing email address when inviting someone' do
    daisy = login_user(users(:daisy))
    post users_path, params: user_params_missing_email
    assert_response :success
    assert_equal 'Ooops, something went wrong', flash[:warning]
  end

  test 'admin is informed about erroneous email address when inviting someone' do
    daisy = login_user(users(:daisy))
    post users_path, params: user_params_wrong_email
    assert_response :success
    assert_equal 'Ooops, something went wrong', flash[:warning]
  end

  private

  def user_params
    {
      user: {
        email: 'newuser@test.foo.bar'
      }
    }
  end

  def user_params_missing_email
    {
      user: {
        email: ''
      }
    }
  end

  def user_params_wrong_email
    {
      user: {
        email: 'nono'
      }
    }
  end
end
