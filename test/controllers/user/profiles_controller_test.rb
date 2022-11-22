require 'test_helper'

class User::ProfilesControllerTest < ActionDispatch::IntegrationTest
  test 'get show' do
    sign_in_user :daisy
    get user_profile_path

    assert_response :success
  end

  test 'patch update' do
    user = users(:daisy)
    sign_in_user :daisy

    assert_changes -> { user.locale }, from: 'en', to: 'de' do
      patch user_profile_path, params: {
        user_profile: {
          locale: 'de'
        }
      }
      follow_redirect!

      assert_response :success
      user.reload
    end
  end
end
