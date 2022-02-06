require 'test_helper'

class RecipeIngredientFormTest < ActiveSupport::TestCase
  test '#portion_id, in params' do
    portion = portions(:apple_default_portion)
    recipe_ingredient = recipe_ingredients(:apples_in_apple_pie)
    form = RecipeIngredientForm.new(recipe_ingredient, new_params(portion_id: portion.id))
    assert_equal portion.id, form.portion_id
  end

  test '#portion_id, in object' do
    recipe_ingredient = recipe_ingredients(:apples_in_apple_pie)
    form = RecipeIngredientForm.new(recipe_ingredient, new_params())
    assert_equal recipe_ingredient.portion.id, form.portion_id
  end

  test '#portion_id, default' do
    default_portion = portions(:apple_default_portion)
    recipe_ingredient = RecipeIngredient.new(recipe: recipes(:apple_pie), food: foods(:apple))
    form = RecipeIngredientForm.new(recipe_ingredient, new_params())
    assert_equal default_portion.id, form.portion_id
  end

  test '#amount_in_measure, in params' do
    recipe_ingredient = recipe_ingredients(:apples_in_apple_pie)
    form = RecipeIngredientForm.new(recipe_ingredient, new_params(amount_in_measure: 3))
    assert_equal 3, form.amount_in_measure
  end

  test '#amount_in_measure, from object' do
    recipe_ingredient = recipe_ingredients(:apples_in_apple_pie)
    form = RecipeIngredientForm.new(recipe_ingredient, new_params())
    assert_in_delta(0.03, form.amount_in_measure)
  end

  test '#checked_portion?' do
    not_checked_radio_portion = portions(:apple_default_portion)
    checked_radio_portion = portions(:big_apple_portion)
    recipe_ingredient = recipe_ingredients(:apples_in_apple_pie)
    form = RecipeIngredientForm.new(recipe_ingredient, new_params())

    assert_not form.checked_portion?(not_checked_radio_portion)
    assert form.checked_portion?(checked_radio_portion)
  end

  test '#form_with_arguments and #action_url, new record' do
    form = RecipeIngredientForm.new(RecipeIngredient.new(recipe: recipes(:apple_pie)))
    assert_equal form, form.form_with_arguments[:model]
    assert_match %r{^/recipes/[0-9]+/ingredients$}, form.form_with_arguments[:url]
    assert_equal({ turbo: false }, form.form_with_arguments[:data])
  end

  test '#form_with_arguments and #action_url, existing record' do
    form = RecipeIngredientForm.new(recipe_ingredients(:apples_in_apple_pie))
    assert_equal form, form.form_with_arguments[:model]
    assert_match %r{^/recipes/[0-9]+/ingredients/[0-9]+$}, form.form_with_arguments[:url]
    assert_not form.form_with_arguments.key?(:data)
  end

  private

  def new_params(params = {})
    ActionController::Parameters.new(recipe_ingredient: params)
  end
end
