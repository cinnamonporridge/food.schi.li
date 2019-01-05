require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  test 'detect_vegan for vegan' do
    recipe = recipes(:vegan_peanut_butter_banana)
    recipe.update_columns(vegan: false)

    assert_changes 'recipe.vegan?', from: false, to: true do
      recipe.detect_vegan
    end
  end

  test 'detect_vegan for non vegan' do
    recipe = recipes(:non_vegan_milk_banana)
    recipe.update_columns(vegan: true)

    assert_changes 'recipe.vegan?', from: true, to: false do
      recipe.detect_vegan
    end
  end
end
