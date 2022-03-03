require 'test_helper'

class RecipeIngredientDecoratorTest < ActiveSupport::TestCase
  test '#quantity' do
    assert_nil decorated(:milk_in_apple_pie).quantity
    assert_in_delta 0.03, decorated(:apples_in_apple_pie).quantity
  end

  test '#quantity_with_pieces' do
    assert_nil decorated(:milk_in_apple_pie).quantity_with_pieces

    recipe_ingredient = recipe_ingredients(:apples_in_apple_pie)
    assert_equal '(0.03 pcs)', recipe_ingredient.decorate.quantity_with_pieces

    recipe_ingredient.amount = 200
    assert_equal '(1.0 pc)', recipe_ingredient.decorate.quantity_with_pieces

    recipe_ingredient.amount = 400
    assert_equal '(2.0 pcs)', recipe_ingredient.decorate.quantity_with_pieces
  end

  test '#rounded_amount' do
    assert_equal 40, decorated(:milk_in_apple_pie).rounded_amount
  end

  test '#unit_abbrevation' do
    assert_equal 'ml', decorated(:milk_in_apple_pie).unit_abbrevation
    assert_equal 'g', decorated(:apples_in_apple_pie).unit_abbrevation
  end

  test '#rounded_amount_with_unit_abbrevation' do
    assert_equal '<data class="unit unit-ml">40</data>',
                 decorated(:milk_in_apple_pie).rounded_amount_with_unit_abbrevation
    assert_equal '<data class="unit unit-g">6</data>',
                 decorated(:apples_in_apple_pie).rounded_amount_with_unit_abbrevation
  end

  test '#display_kcal' do
    assert_equal '48', decorated(:milk_in_apple_pie).display_kcal
  end

  test '#display_carbs' do
    assert_equal '48', decorated(:milk_in_apple_pie).display_carbs
  end

  test '#display_protein' do
    assert_equal '48', decorated(:milk_in_apple_pie).display_protein
  end

  test '#display_fat' do
    assert_equal '48', decorated(:milk_in_apple_pie).display_fat
  end

  test '.measures_collection' do
    assert_equal [['g/ml', 'unit'], %w[Pieces piece]],
                 RecipeIngredientDecorator.measures_collection
  end

  private

  def decorated(fixture_key)
    recipe_ingredients(fixture_key).decorate
  end
end
