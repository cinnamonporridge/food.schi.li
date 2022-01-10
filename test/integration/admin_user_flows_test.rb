require 'test_helper'

class AdminUserFlowsTest < ActionDispatch::IntegrationTest
  test 'admin logs in' do
    get login_path
    login_user(users(:daisy))

    assert_select 'h1', 'My journal days'

    assert_select 'nav a', text: 'Journal'
    assert_select 'nav a', text: 'Recipes'
    assert_select 'nav a', text: 'Foods'
    assert_select 'nav button', 'Sign out'
  end
end
