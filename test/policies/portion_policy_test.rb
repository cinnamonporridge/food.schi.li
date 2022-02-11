require 'test_helper'

class PortionPolicyTest < ActiveSupport::TestCase
  # read
  test '#scope, admin :read' do
    PortionPolicy.scope_for_user(users(:daisy), :read).tap do |scope|
      assert_includes scope, portions(:milk_tablespoon_portion), 'should read own portion'
      assert_includes scope, portions(:big_apple_portion), 'should read global portion'
      assert_not_includes scope, portions(:maple_syrup_tablespoon_portion), 'should NOT read other portion'
    end
  end

  test '#scope, non-admin :read' do
    PortionPolicy.scope_for_user(users(:john), :read).tap do |scope|
      assert_not_includes scope, portions(:milk_tablespoon_portion), 'should NOT read other portion'
      assert_includes scope, portions(:big_apple_portion), 'should read global portion'
      assert_includes scope, portions(:maple_syrup_tablespoon_portion), 'should not read other portion'
    end
  end

  # write
  test '#scope, admin :write' do
    PortionPolicy.scope_for_user(users(:daisy), :write).tap do |scope|
      assert_includes scope, portions(:milk_tablespoon_portion), 'should write own portion'
      assert_includes scope, portions(:big_apple_portion), 'should write global portion'
      assert_not_includes scope, portions(:maple_syrup_tablespoon_portion), 'should NOT write other portion'
    end
  end

  test '#scope, non-admin :write' do
    PortionPolicy.scope_for_user(users(:john), :write).tap do |scope|
      assert_not_includes scope, portions(:milk_tablespoon_portion), 'should NOT write other portion'
      assert_not_includes scope, portions(:big_apple_portion), 'should NOT write global portion'
      assert_includes scope, portions(:maple_syrup_tablespoon_portion), 'should not read other portion'
    end
  end
end
