require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test 'should not get show without login' do
    get home_url
    assert_response :redirect
  end
end
