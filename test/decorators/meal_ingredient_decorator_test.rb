require 'test_helper'

class MealIngredientDecoratorTest < ActiveSupport::TestCase
  test '#quantity' do
    assert_nil decorated(:johns_apple_on_january_first).quantity
    assert_in_delta 0.01, decorated(:daisys_big_apple_meal_ingredient_on_february_first).quantity
  end

  test '#quantity_with_pieces' do
    assert_nil decorated(:johns_apple_on_january_first).quantity_with_pieces

    meal_ingredient = meal_ingredients(:daisys_big_apple_meal_ingredient_on_february_first)
    assert_equal '(0.01 pcs)', meal_ingredient.decorate.quantity_with_pieces

    meal_ingredient.amount = 200
    assert_equal '(1.0 pc)', meal_ingredient.decorate.quantity_with_pieces

    meal_ingredient.amount = 400
    assert_equal '(2.0 pcs)', meal_ingredient.decorate.quantity_with_pieces
  end

  test '#unit_abbrevation' do
    assert_equal 'g', decorated(:johns_apple_on_january_first).unit_abbrevation
    assert_equal 'ml', decorated(:daisys_glass_of_milk_meal_ingredient_on_february_first).unit_abbrevation
  end

  test '#rounded_amount_with_unit_abbrevation' do
    assert_equal '<data class="unit unit-g">180</data>',
                 decorated(:johns_apple_on_january_first).rounded_amount_with_unit_abbrevation
    assert_equal '<data class="unit unit-ml">250</data>',
                 decorated(:daisys_glass_of_milk_meal_ingredient_on_february_first).rounded_amount_with_unit_abbrevation
  end

  test '#display_portion_name' do
    assert_equal 'Apple', decorated(:johns_apple_on_january_first).display_portion_name
  end

  private

  def decorated(fixture_key)
    meal_ingredients(fixture_key).decorate
  end
end
