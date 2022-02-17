require 'test_helper'

class VeganDetection::RecipeTest < ActiveSupport::TestCase
  test 'updates non-vegan recipe' do
    non_vegan_recipe = recipes(:non_vegan_milk_banana)
    non_vegan_recipe.update(vegan: true)

    assert_changes -> { non_vegan_recipe.vegan }, to: false do
      VeganDetection::Recipe.new(non_vegan_recipe).call!
      non_vegan_recipe.reload
    end
  end

  test 'updates vegan recipe, all ingredients are vegan' do
    vegan_recipe = recipes(:vegan_peanut_butter_banana)
    vegan_recipe.update(vegan: false)

    assert_changes -> { vegan_recipe.vegan }, to: true do
      VeganDetection::Recipe.new(vegan_recipe).call!
      vegan_recipe.reload
    end
  end

  test 'updates vegan recipe, no ingredients' do
    vegan_recipe = recipes(:vegan_peanut_butter_banana)
    vegan_recipe.recipe_ingredients.destroy_all
    vegan_recipe.update(vegan: false)

    assert_changes -> { vegan_recipe.vegan }, to: true do
      VeganDetection::Recipe.new(vegan_recipe).call!
      vegan_recipe.reload
    end
  end

  test 'updates non-vegan recipe, food changes to non-vegan' do
    vegan_recipe = recipes(:vegan_peanut_butter_banana)
    food = foods(:peanut_butter)
    food.update!(vegan: false)

    assert_changes -> { vegan_recipe.vegan }, to: false do
      VeganDetection::Recipe.new(food).call!
      vegan_recipe.reload
    end
  end
end
