require 'test_helper'
require 'capybara/rails'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :rack_test

  def sign_in_user(user, password = 'abc')
    visit login_path
    fill_in 'Email address', with: user.email
    fill_in 'Password', with: password
    click_on 'Sign in'
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
