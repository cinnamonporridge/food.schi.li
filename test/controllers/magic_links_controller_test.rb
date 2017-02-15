require 'test_helper'

class MagicLinksControllerTest < ActionDispatch::IntegrationTest
  test 'should get new with wrong challenge' do
    get magic_link_path(challenge: 'wrongchallenge')
    assert_response :success
    assert_equal 'Magic link challenge is not correct', flash[:warning]
  end

  test 'should login with magic link' do
    john = magic_link(users(:john))
    get magic_link_path(challenge: john.magic_link_challenge)
    follow_redirect!
    assert_response :success
    assert_equal 'Login successful', flash[:success]

    john.reload
    assert_nil john.magic_link_challenge
    assert_nil john.magic_link_sent_at
  end

  private

  def magic_link(user)
    PasswordService.magic_link!(user)
    user.reload
  end
end
