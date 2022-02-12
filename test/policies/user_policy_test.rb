require 'test_helper'

class UserPolicyTest < ActiveSupport::TestCase
  test '#scope for admin' do
    scope = new_policy(users(:daisy)).scope
    assert_equal 2, scope.count
    assert_includes scope, users(:daisy)
    assert_includes scope, users(:global)
  end

  test '#scope for non-admin' do
    scope = new_policy(users(:john)).scope
    assert_equal 1, scope.count
    assert_includes scope, users(:john)
  end

  private


  def new_policy(...)
    self.class.to_s.sub(/Test$/, '').constantize.new(...)
  end
end
