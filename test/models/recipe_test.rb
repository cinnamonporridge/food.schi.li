require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  test 'detect_vegan for vegan' do
    recipe = recipes(:vegan_peanut_butter_banana)
    recipe.update_columns(vegan: false) # rubocop:disable Rails/SkipsModelValidations

    assert_changes 'recipe.vegan?', from: false, to: true do
      recipe.detect_vegan
    end
  end

  test 'detect_vegan for non vegan' do
    recipe = recipes(:non_vegan_milk_banana)
    recipe.update_columns(vegan: true) # rubocop:disable Rails/SkipsModelValidations

    assert_changes 'recipe.vegan?', from: true, to: false do
      recipe.detect_vegan
    end
  end

  test 'search' do
    Recipe.search('An').tap do |result|
      assert_includes result, recipes(:anchovy_soup)
      assert_includes result, recipes(:vegan_peanut_butter_banana)
      assert_includes result, recipes(:non_vegan_milk_banana)
      assert_not_includes result, recipes(:apple_pie)
    end
  end
end
