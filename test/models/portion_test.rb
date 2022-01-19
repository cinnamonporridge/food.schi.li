require 'test_helper'

class PortionTest < ActiveSupport::TestCase
  test '#deletable' do
    portion = portions(:sugar_cube_portion)
    assert portion.deleteable?, 'should be deleteable because it is not used in a meal or recipe'
  end

  test 'not #deletable, referenced in meal' do
    portion = portions(:big_apple_portion)
    journal_day = journal_days(:john_january_first)

    assert_not portion.deleteable?, 'should not be deleteable because it is used in a meal'
  end

  test 'not #deletable, referenced in recipe' do
    portion = portions(:sugar_cube_portion)
    recipe = recipes(:apple_pie)

    Ingredient.create!(recipe:, portion:, amount: 4)
    assert_not portion.deleteable?, 'should not be deleteable because it is used in a recipe'
  end
end
