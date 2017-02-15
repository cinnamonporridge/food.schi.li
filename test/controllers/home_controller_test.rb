require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test 'should not get show without login' do
    get home_url
    assert_response :redirect
  end

  test 'should get new after login' do
    john = users(:john)
    login_user(john)
    get home_url
    assert_response :success
  end
end
