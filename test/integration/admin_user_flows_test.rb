require 'test_helper'

class AdminUserFlowsTest < ActionDispatch::IntegrationTest
  test 'admin logs in' do
    get login_path
    login_user(users(:daisy))

    assert_select 'h1', 'Search'

    assert_select 'ul.menu' do
      expected_texts = ['Home', 'Journal', 'Recipes', 'Foods', 'Users', 'Log out']
      css_select('li').each_with_index do |li, i|
        assert_equal expected_texts[i], li.inner_text.strip
      end
    end
  end
end
