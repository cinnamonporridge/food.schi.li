require 'test_helper'

class Recipes::IngredientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recipe = recipes(:apple_pie)
    @recipe_ingredient = recipe_ingredients(:apples_in_apple_pie)
    @vegan_recipe = recipes(:vegan_peanut_butter_banana)
    @vegan_recipe_ingredient = recipe_ingredients(:peanut_butter_in_vegan_peanut_butter_banana)
  end

  # new
  test 'get #new' do
    sign_in_user :daisy
    get new_recipe_ingredient_path(@recipe)
    assert_response :success
  end

  test 'not get #new for other' do
    sign_in_user :john
    assert_not_get new_recipe_ingredient_path(@recipe)
  end

  test 'not get #new for archived recipe' do
    @recipe.archive
    sign_in_user :daisy
    assert_not_get new_recipe_ingredient_path(@recipe)
  end

  # create
  test 'post #create' do
    sign_in_user :daisy
    portion = portions(:sugar_cube_portion)

    assert_difference -> { @recipe.recipe_ingredients.count } do
      post recipe_ingredients_path(@recipe), params: {
        recipe_ingredient: {
          food_name: portion.food.name, # not directly needed, only for FoodSearchForm
          portion_id: portion.id,
          amount_in_measure: '3'
        }
      }
      follow_redirect!
      assert_response :success
      assert_equal 'Ingredient added', flash[:notice]
    end

    @recipe.recipe_ingredients.last.tap do |recipe_ingredient|
      assert_equal portion, recipe_ingredient.portion
      assert_in_delta 75.0, recipe_ingredient.amount
    end
  end

  test 'not post #create for other' do
    @recipe.archive
    sign_in_user :john
    assert_not_post recipe_ingredients_path(@recipe)
  end

  test 'not post #create for archived' do
    @recipe.archive
    sign_in_user :daisy
    assert_not_post recipe_ingredients_path(@recipe)
  end

  test 'decimal amount is allowed' do
    sign_in_user :daisy
    portion = portions(:sugar_cube_portion)

    assert_difference -> { RecipeIngredient.count } do
      post recipe_ingredients_path(@recipe), params: {
        recipe_ingredient: {
          food_name: portion.food.name, # not directly needed, only for FoodSearchForm
          portion_id: portion.id,
          amount_in_measure: '1.77'
        }
      }
      follow_redirect!
      assert_response :success
    end

    # 1.77 pieces of 25g sugar cube = 44.25g
    @recipe.reload
    assert_in_delta(44.25, @recipe.recipe_ingredients.last.amount)
  end

  test 'adding a non vegan ingredient changes recipe to non-vegan' do
    sign_in_user :daisy
    portion = portions(:milk_default_portion)

    assert_changes -> { @vegan_recipe.vegan? }, to: false do
      post recipe_ingredients_path(@vegan_recipe), params: {
        recipe_ingredient: {
          food_name: portion.food.name,
          portion_id: portion.id,
          amount_in_measure: '102',
        }
      }
      follow_redirect!
      assert_response :success
      @vegan_recipe.reload
    end

    assert_in_delta(102.0, @vegan_recipe.recipe_ingredients.last.amount)
  end

  test 'adding a vegan ingredient to a vegan recipe should not change recipe to non-vegan' do
    sign_in_user :daisy
    portion = portions(:sugar_cube_portion)

    assert_no_changes -> { @vegan_recipe.vegan? } do
      post recipe_ingredients_path(@vegan_recipe), params: {
        recipe_ingredient: {
          food_name: portion.food.name, # not directly needed, only for FoodSearchForm
          portion_id: portion.id,
          amount_in_measure: '1',
        }
      }
      follow_redirect!
      assert_response :success
      @vegan_recipe.reload
    end
  end

  test 'adding a vegan ingredient to a non-vegan recipe should not change recipe to vegan' do
    sign_in_user :daisy
    portion = portions(:sugar_cube_portion)

    assert_no_changes -> { @recipe.vegan? } do
      post recipe_ingredients_path(@recipe), params: {
        recipe_ingredient: {
          food_name: portion.food.name, # not directly needed, only for FoodSearchForm
          portion_id: portion.id,
          amount_in_measure: '1'
        }
      }
      follow_redirect!
      assert_response :success
      @vegan_recipe.reload
    end
  end

  # edit
  test 'get #edit' do
    sign_in_user :daisy
    get edit_recipe_ingredient_path(@recipe, @recipe_ingredient)
    assert_response :success
  end

  test 'not get #edit for other' do
    sign_in_user :john
    assert_not_get edit_recipe_ingredient_path(@recipe, @recipe_ingredient)
  end

  test 'not get #edit for archived' do
    @recipe.archive
    sign_in_user :daisy
    assert_not_get edit_recipe_ingredient_path(@recipe, @recipe_ingredient)
  end

  # update
  test 'patch #update' do
    sign_in_user :daisy

    assert_changes -> { @recipe_ingredient.amount }, to: 2800.0 do
      patch recipe_ingredient_path(@recipe, @recipe_ingredient), params: {
        recipe_ingredient: {
          portion_name: 'Apple Big Apple (200g)',
          amount_in_measure: '14',
          measure: 'piece'
        }
      }
      follow_redirect!
      assert_response :success
      assert_equal 'Ingredient updated', flash[:notice]
      @recipe_ingredient.reload
    end
  end

  test 'not patch #update for other' do
    sign_in_user :john
    assert_not_patch recipe_ingredient_path(@recipe, @recipe_ingredient)
  end

  test 'not patch #update for archived' do
    @recipe.archive
    sign_in_user :daisy
    assert_not_patch recipe_ingredient_path(@recipe, @recipe_ingredient)
  end

  test 'changing an ingredient from vegan to non-vegan changes recipe to non-vegan' do
    sign_in_user :daisy

    assert_changes -> { @vegan_recipe.vegan? }, from: true, to: false do
      patch recipe_ingredient_path(@vegan_recipe, @vegan_recipe_ingredient), params: {
        recipe_ingredient: {
          portion_name: 'Milk (100ml)',
          amount_in_measure: '100',
          measure: 'unit'
        }
      }
      follow_redirect!
      assert_response :success
      @vegan_recipe.reload
    end
  end

  test 'changing a vegan ingredient to another vegan ingredient should not change recipe to non-vegan' do
    sign_in_user :daisy

    assert_no_changes -> { @recipe.vegan? } do
      patch recipe_ingredient_path(@vegan_recipe, @vegan_recipe_ingredient), params: {
        recipe_ingredient: {
          portion_name: 'Sugar Cube (25g)',
          amount_in_measure: '100',
          measure: 'unit'
        }
      }
      follow_redirect!
      assert_response :success
      @recipe.reload
    end
  end

  # destroy
  test 'delete #destroy' do
    sign_in_user :daisy

    assert_difference -> { @recipe.recipe_ingredients.count }, -1 do
      delete recipe_ingredient_path(@recipe, @recipe_ingredient)
      follow_redirect!
      assert_response :success
      assert_equal 'Ingredient deleted', flash[:notice]
    end

    assert_raises(ActiveRecord::RecordNotFound) do
      @recipe_ingredient.reload
    end
  end

  test 'not delete #destroy for other' do
    sign_in_user :john
    assert_not_delete recipe_ingredient_path(@recipe, @recipe_ingredient)
  end

  test 'not delete #destroy for archived' do
    @recipe.archive
    sign_in_user :daisy
    assert_not_delete recipe_ingredient_path(@recipe, @recipe_ingredient)
  end

  test 'removing the only non-vegan ingredient changes the recipe to vegan' do
    sign_in_user :daisy

    non_vegan_recipe_ingredient = recipe_ingredients(:milk_in_apple_pie)

    assert_changes -> { @recipe.vegan? }, to: true do
      delete recipe_ingredient_path(@recipe, non_vegan_recipe_ingredient)
      follow_redirect!
      assert_response :success
      @recipe.reload
    end
  end
end
