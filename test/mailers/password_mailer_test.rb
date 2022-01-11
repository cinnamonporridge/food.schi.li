require 'test_helper'

class PasswordMailerTest < ActionMailer::TestCase
  test 'reset link mail' do
    john = users(:john)
    PasswordService.reset_link!(john)
    email = PasswordMailer.reset_link_mail(john)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal %w[john@foo.bar], email.to
    assert_equal %w[kitchen@food.schi.li], email.from
    assert_equal 'Your password reset link', email.subject
  end
end
