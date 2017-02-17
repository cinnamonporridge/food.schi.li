require 'test_helper'

class AdminUserFlowsTest < ActionDispatch::IntegrationTest
  test 'admin logs in' do
    get login_path
    login_user(users(:daisy))

    assert_select 'h1', 'Home'

    assert_select 'ul.home-menu' do 
      assert_select 'li', 4
    end

  end
end
