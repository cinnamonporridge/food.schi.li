require 'test_helper'

class RegularUserFlowsTest < ActionDispatch::IntegrationTest
  test 'regular user logs in' do 
    get login_path
    login_user(users(:john))

    assert_select 'h1', 'Home'

    assert_select 'ul.home-menu' do
      assert_select 'li', 3
    end
  end
end
