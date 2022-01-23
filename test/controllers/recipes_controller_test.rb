require 'test_helper'

class RecipesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recipe = recipes(:apple_pie)
  end

  # index
  test 'get #index' do
    login_user :daisy
    get recipes_path
    assert_response :success
  end

  # show
  test 'get #show' do
    login_user :daisy
    get recipes_path(@recipe)
    assert_response :success
  end

  test 'cannot get #show of other' do
    login_user :john
    assert_not_get recipe_path(@recipe)
  end

  # new
  test 'get #new' do
    login_user :daisy
    get new_recipe_path
    assert_response :success
  end

  # create
  test 'post #create' do
    login_user :daisy
    user = users(:daisy)

    assert_difference -> { user.recipes.count }, +1 do
      post recipes_path, params: {
        recipe: {
          name: 'Tomato soup',
          servings: '4'
        }
      }
      follow_redirect!
      assert_response :success
      assert_notice 'Recipe added'
    end

    user.recipes.last do |recipe|
      assert_equal 'Tomato soup', recipe.name
      assert_equal 4, recipe.servings
    end
  end

  # edit
  test 'get #edit' do
    login_user :daisy
    get edit_recipe_path(@recipe)
    assert_response :success
  end

  test 'cannot get #edit of other' do
    login_user :john
    assert_not_get edit_recipe_path(@recipe)
  end

  # update
  test 'patch #update' do
    login_user :daisy

    patch recipe_path(@recipe), params: {
      recipe: {
        name: 'Apple Cake',
        servings: '7'
      }
    }
    follow_redirect!
    assert_response :success
    assert_notice 'Recipe updated'

    @recipe.reload

    assert_equal 'Apple Cake', @recipe.name
    assert_equal 7, @recipe.servings
  end

  test 'cannot patch #update of other' do
    login_user :john
    assert_not_patch recipe_path(@recipe)
  end

  # destroy
  test 'delete #destroy' do
    login_user :daisy
    user = users(:daisy)

    recipe = user.recipes.create!(name: 'To be deleted', servings: 33)

    assert_difference -> { user.recipes.count }, -1 do
      delete recipe_path(recipe)
      follow_redirect!
      assert_response :success
      assert_notice 'Recipe deleted'
    end

    assert_raises(ActiveRecord::RecordNotFound) do
      recipe.reload
    end
  end

  test 'cannot delete #destroy of other' do
    login_user :john
    assert_not_delete recipe_path(@recipe)
  end
end
