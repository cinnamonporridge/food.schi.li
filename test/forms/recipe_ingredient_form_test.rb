require 'test_helper'

class RecipeIngredientFormTest < ActiveSupport::TestCase
  def setup
    @recipe = recipes(:apple_pie)
    @new_ingredient = @recipe.recipe_ingredients.new
  end

  test 'correct values with unit option' do
    form = RecipeIngredientForm.new(@new_ingredient, sugar_with_unit_params)

    assert_difference -> { @recipe.recipe_ingredients.count }, +1 do
      assert form.save
    end
  end

  test 'correct values with pieces option' do
    form = RecipeIngredientForm.new(@new_ingredient, sugar_cubes_pieces_params)

    assert_difference -> { @recipe.recipe_ingredients.count }, +1 do
      assert form.save
    end
  end

  private

  def sugar_with_unit_params
    {
      portion_name: 'Sugar (100g)',
      amount_in_measure: '300',
      measure: 'unit'
    }
  end

  def sugar_cubes_pieces_params
    {
      portion_name: 'Sugar Cube (25g)',
      amount_in_measure: '5',
      measure: 'piece'
    }
  end
end
