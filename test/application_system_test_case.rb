require 'test_helper'
require 'capybara/rails'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :rack_test

  def sign_in_user(fixture_key, password = 'abc')
    user = users(fixture_key)
    visit login_path
    fill_in 'Email address', with: user.email
    fill_in 'Password', with: password
    click_on 'Sign in'
  end

  def sign_out
    click_on 'Sign out'
  end

  def navigate_to(menu_item)
    within('nav.main-nav') do
      click_on menu_item, match: :first
    end
  end

  def using_browser(&)
    driver = ENV['DEBUG'].present? ? :selenium : :selenium_headless
    Capybara.using_driver(driver, &)
  end

  def click_with_delete(element)
    if Capybara.current_driver == :rack_test
      page.driver.submit :delete, element['href'], {}
    else
      element.click
      accept_alert
    end
  end
end
