require 'test_helper'

class RegularUserFlowsTest < ActionDispatch::IntegrationTest
  def setup
    login_user(users(:john))
  end

  test 'regular user logs in' do
    assert_select 'h1', 'My journal days'

    assert_select 'nav a', 'Journal'
    assert_select 'nav a', 'Recipes'
    assert_select 'nav a', 'Foods'
    assert_select 'nav button', 'Sign out'
  end

  # home
  test 'user visits home page' do
    get journal_days_path
    assert_response :success
    assert_select 'h1', 'My journal days'
  end

  # recipes
  test 'user visits recipes page' do
    get recipes_path
    assert_response :success
    assert_select 'h1', 'Recipes'
  end
end
