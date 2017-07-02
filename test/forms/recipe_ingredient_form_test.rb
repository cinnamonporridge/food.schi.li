require 'test_helper'

class RecipeIngredientFormTest < ActiveSupport::TestCase

  def setup
    @new_ingredient = recipes(:apple_pie).ingredients.new
  end

  test 'correct values with unit option' do
    form = RecipeIngredientForm.new(sugar_with_unit_params.merge(ingredient: @new_ingredient))

    assert_equal portions(:sugar_default_portion), form.values[:portion]
    assert_equal '300', form.values[:amount]
  end

  test 'correct values with pieces option' do
    form = RecipeIngredientForm.new(sugar_cubes_pieces_params.merge(ingredient: @new_ingredient))

    assert_equal portions(:sugar_cube_portion), form.values[:portion]
    assert_equal 125, form.values[:amount]
  end

  private

  def sugar_with_unit_params
    {
      portion_id: portions(:sugar_default_portion).id,
      amount_in_measure: '300',
      measure: 'unit'
    }
  end

  def sugar_cubes_pieces_params
    {
      portion_id: portions(:sugar_cube_portion).id,
      amount_in_measure: '5',
      measure: 'piece'
    }
  end
end

