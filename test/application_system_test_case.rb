require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :rack_test

  def login_user(user, password = 'abc')
    visit login_path
    fill_in 'Email address', with: user.email
    fill_in 'Password', with: password
    click_on 'Log in'
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
