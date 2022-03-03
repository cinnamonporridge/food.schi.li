require 'test_helper'

class PortionDecoratorTest < ActiveSupport::TestCase
  test '#name_for_dropdown' do
    assert_equal 'Apple (100g)', decorate(:apple_default_portion).name_for_dropdown
  end

  test '#display_measure' do
    assert_equal 'g/ml', decorate(:apple_default_portion).display_measure
  end

  test '#amount_with_unit_abbrevation' do
    assert_equal '100g', decorate(:apple_default_portion).amount_with_unit_abbrevation
  end

  test '#display_amount_with_unit_abbreviation_after' do
    assert_equal '<span class="unit unit-g">100</span>',
                 decorate(:apple_default_portion).display_amount_with_unit_abbreviation_after
  end

  test '#name_with_food' do
    assert_equal 'Apple', decorate(:apple_default_portion).name_with_food
    assert_equal 'Apple Big Apple', decorate(:big_apple_portion).name_with_food
  end

  test '#display_name' do
    assert_equal 'Base', decorate(:apple_default_portion).display_name
    assert_equal 'Big Apple', decorate(:big_apple_portion).display_name
  end

  private

  def decorate(fixture_key)
    portions(fixture_key).decorate
  end
end
