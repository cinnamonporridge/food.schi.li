require 'test_helper'

class RecipeCopyServiceTest < ActiveSupport::TestCase
  test 'copies a recipe' do
    base_recipe = recipes(:peanut_butter_bread)

    service = RecipeCopyService.new(base_recipe, 'PB&J Copy')

    assert_difference -> { Recipe.where(name: 'PB&J Copy').count }, 1 do
      new_recipe = service.copy
      new_recipe.save!

      assert new_recipe.ingredients.count.positive?

      assert_equal base_recipe.ingredients.count,
                   new_recipe.ingredients.count,
                   'Base recipe and new recipe should have same ingredients count'
    end
  end
end
