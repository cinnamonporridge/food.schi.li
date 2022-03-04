require 'test_helper'

class UserProfileFormTest < ActiveSupport::TestCase
  test '.save' do
    user = users(:daisy)

    assert_changes -> { user.locale }, from: 'en', to: 'de' do
      form = UserProfileForm.new(user, new_params(user_profile: { locale: 'de' }))
      assert form.save
      user.reload
    end
  end

  private

  def new_params(...)
    ActionController::Parameters.new(...)
  end
end
