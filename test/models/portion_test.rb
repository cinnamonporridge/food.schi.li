require 'test_helper'

class PortionTest < ActiveSupport::TestCase
  test '#deletable' do
    portion = portions(:sugar_cube_portion)
    assert_predicate portion, :deleteable?, 'should be deleteable because it is not used in a meal or recipe'
  end

  test 'not #deletable, referenced in meal' do
    portion = portions(:big_apple_portion)
    assert_not portion.deleteable?, 'should not be deleteable because it is used in a meal'
  end

  test 'not #deletable, referenced in recipe' do
    portion = portions(:sugar_cube_portion)
    recipe = recipes(:apple_pie)

    RecipeIngredient.create!(recipe:, portion:, amount: 4)
    assert_not portion.deleteable?, 'should not be deleteable because it is used in a recipe'
  end

  test '#measure' do
    portion = portions(:apple_default_portion)
    assert_changes -> { portion.measure }, from: :unit, to: :piece do
      portion.amount = 0
    end
  end
end
