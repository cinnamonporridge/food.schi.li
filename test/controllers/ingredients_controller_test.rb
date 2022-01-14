require 'test_helper'

class IngredientsControllerTest < ActionDispatch::IntegrationTest
  def setup
    login_user :john
  end

  test 'decimal amount is allowed' do
    recipe = recipes(:apple_pie)
    portion = portions(:sugar_cube_portion)

    assert_difference('Ingredient.count') do
      post recipe_ingredients_path(recipe),
           params: {
             recipe_ingredient: {
               portion_name: 'Sugar Cube (25g)',
               amount_in_measure: '1.77',
               measure: 'piece'
             }
           }
    end

    # 1.77 pieces of 25g sugar cube = 44.25g
    recipe.reload
    assert_in_delta(44.25, recipe.ingredients.find_by(portion:).amount)
  end

  test 'adding a non vegan ingredient changes recipe to non-vegan' do
    recipe = recipes(:vegan_peanut_butter_banana)
    portion = portions(:milk_default_portion)

    assert_not portion.food.vegan?, 'Portion nutrution should be non-vegan'

    assert_changes 'recipe.vegan?', from: true, to: false do
      post recipe_ingredients_path(recipe),
           params: {
             recipe_ingredient: {
               portion_name: 'Milk (100ml)',
               amount_in_measure: '100',
               measure: 'unit'
             }
           }
      recipe.reload
    end
  end

  test 'changing an ingredient from vegan to non-vegan changes recipe to non-vegan' do
    recipe = recipes(:vegan_peanut_butter_banana)
    old_ingredient = ingredients(:peanut_butter_in_vegan_peanut_butter_banana)
    new_ingredient_portion = portions(:milk_default_portion)

    assert_not new_ingredient_portion.food.vegan?, 'New ingredient portion nutrution should be non-vegan'

    assert_changes 'recipe.vegan?', from: true, to: false do
      patch recipe_ingredient_path(recipe, old_ingredient),
            params: {
              recipe_ingredient: {
                portion_name: 'Milk (100ml)',
                amount_in_measure: '100',
                measure: 'unit'
              }
            }
      recipe.reload
    end
  end

  test 'adding a vegan ingredient to a vegan recipe should not change recipe to non-vegan' do
    recipe = recipes(:vegan_peanut_butter_banana)
    vegan_portion = portions(:sugar_cube_portion)

    assert vegan_portion.food.vegan?, 'Portion to be added should be vegan'

    assert_no_changes 'recipe.vegan?' do
      post recipe_ingredients_path(recipe),
           params: {
             recipe_ingredient: {
               portion_name: 'Sugar Cube (25g)',
               amount_in_measure: '1',
               measure: 'piece'
             }
           }
      recipe.reload
    end
  end

  test 'changing a vegan ingredient to another vegan ingredient should not change recipe to non-vegan' do
    recipe = recipes(:vegan_peanut_butter_banana)
    old_ingredient = ingredients(:peanut_butter_in_vegan_peanut_butter_banana)
    new_ingredient_portion = portions(:sugar_cube_portion)

    assert new_ingredient_portion.food.vegan?, 'New ingredient portion should be vegan'

    assert_no_changes 'recipe.vegan?' do
      patch recipe_ingredient_path(recipe, old_ingredient),
            params: {
              recipe_ingredient: {
                portion_name: 'Sugar Cube (25g)',
                amount_in_measure: '100',
                measure: 'unit'
              }
            }
      recipe.reload
    end
  end

  test 'adding a vegan ingredient to a non-vegan recipe should not change recipe to vegan' do
    recipe = recipes(:non_vegan_milk_banana)
    new_ingredient_portion = portions(:peanut_butter_default_portion)

    assert new_ingredient_portion.food.vegan?, 'New ingredient portion should be vegan'

    assert_no_changes 'recipe.vegan?' do
      post recipe_ingredients_path(recipe),
           params: {
             recipe_ingredient: {
               portion_id: new_ingredient_portion.id,
               amount_in_measure: '1',
               measure: 'piece'
             }
           }
      recipe.reload
    end
  end

  test 'changing all non-vegan to vegan ingredients should change recipe to vegan' do
    recipe = recipes(:non_vegan_milk_banana)
    non_vegan_ingredient = ingredients(:milk_in_non_vegan_milk_banana)
    new_ingredient_portion = portions(:peanut_butter_default_portion)

    assert new_ingredient_portion.food.vegan?, 'New ingredient portion should be vegan'

    assert_changes 'recipe.vegan?', from: false, to: true do
      patch recipe_ingredient_path(recipe, non_vegan_ingredient),
            params: {
              recipe_ingredient: {
                portion_name: 'Peanut Butter (100g)',
                amount_in_measure: '100',
                measure: 'unit'
              }
            }
      recipe.reload
    end
  end

  test 'removing the only non-vegan ingredient changes the recipe to vegan' do
    recipe = recipes(:non_vegan_milk_banana)
    non_vegan_ingredient = ingredients(:milk_in_non_vegan_milk_banana)

    assert_changes 'recipe.vegan?', from: false, to: true do
      delete recipe_ingredient_path(recipe, non_vegan_ingredient)
      recipe.reload
    end
  end
end
