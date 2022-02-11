require 'test_helper'

class FoodPolicyTest < ActiveSupport::TestCase
  # read
  test '.scope_for_user, admin :read' do
    FoodPolicy.scope_for_user(users(:daisy), :read).tap do |scope|
      assert_includes scope, foods(:milk), 'should read own food'
      assert_includes scope, foods(:apple), 'should read global food'
      assert_not_includes scope, foods(:maple_syrup), 'should NOT read other food'
    end
  end

  test '#scope, non-admin :read' do
    FoodPolicy.scope_for_user(users(:john), :read).tap do |scope|
      assert_not_includes scope, foods(:milk), 'should NOT read other food'
      assert_includes scope, foods(:apple), 'should read global food'
      assert_includes scope, foods(:maple_syrup), 'should not read other food'
    end
  end

  # write
  test '#scope, admin :write' do
    FoodPolicy.scope_for_user(users(:daisy), :write).tap do |scope|
      assert_includes scope, foods(:milk), 'should write own food'
      assert_includes scope, foods(:apple), 'should write global food'
      assert_not_includes scope, foods(:maple_syrup), 'should NOT write other food'
    end
  end

  test '#scope, non-admin :write' do
    FoodPolicy.scope_for_user(users(:john), :write).tap do |scope|
      assert_not_includes scope, foods(:milk), 'should NOT write other food'
      assert_not_includes scope, foods(:apple), 'should NOT write global food'
      assert_includes scope, foods(:maple_syrup), 'should not read other food'
    end
  end
end
