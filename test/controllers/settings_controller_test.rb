require 'test_helper'

class SettingsControllerTest < ActionDispatch::IntegrationTest
  test 'get #index' do
    login_user :daisy
    get settings_path
    assert_response :success
  end
end
