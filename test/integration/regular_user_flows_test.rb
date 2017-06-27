require 'test_helper'

class RegularUserFlowsTest < ActionDispatch::IntegrationTest

  def setup
    login_regular_user
  end

  test 'regular user logs in' do 
    assert_select 'h1', 'Search'

    assert_select 'ul.menu' do
      expected_texts = ['Home', 'Recipes', 'Foods', 'Log out']
      css_select('li').each_with_index do |li, i|
        assert_equal expected_texts[i], li.inner_text.strip
      end
    end
  end

  # home
  test 'user visits home page' do
    get home_path
    assert_response :success
    assert_select 'h1', 'Search'
  end

  # recipes
  test 'user visits recipes page' do
    get recipes_path
    assert_response :success
    assert_select 'h1', 'Recipes'
  end

  # nutritions
  test 'user visits nutritions page' do
    get nutritions_path
    assert_response :success
    assert_select 'h1', 'Nutritions'
    assert_select 'a.primary.button', 'New nutrition'
  end

  test 'user adds a new nutrition page' do
    get new_nutrition_path
    assert_response :success
    assert_select 'h1', 'New nutrition'
  end

  private

  def login_regular_user
    get login_path
    assert_response :success
    login_user(users(:john))
    assert_response :success
  end
end
