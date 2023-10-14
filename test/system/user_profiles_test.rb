require 'application_system_test_case'

class UserProfilesTest < ApplicationSystemTestCase
  test 'user changes language' do
    sign_in_user :daisy
    navigate_to 'Settings'
    click_link 'Profile'

    assert_selector 'h1', text: 'Profile'
    assert_select 'Language', options: %w[Deutsch English]
    assert_select 'Language', selected: 'English'
    assert_link 'Cancel', href: '/settings'

    select 'Deutsch', from: 'Language'
    click_button 'Update profile'

    assert_selector '.flash', text: 'Profil wurde aktualisiert'
    assert_select 'Sprache', selected: 'Deutsch'
    assert_selector 'h1', text: 'Profil'

    select 'English', from: 'Sprache'
    click_button 'Profil aktualisieren'

    assert_selector '.flash', text: 'Profile updated'
    assert_select 'Language', selected: 'English'
    assert_selector 'h1', text: 'Profile'
  end
end
