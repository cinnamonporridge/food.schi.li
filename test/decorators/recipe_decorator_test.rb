require 'test_helper'

class RecipeDecoratorTest < ActiveSupport::TestCase
  test 'name_with_servings' do
    assert_equal 'Anchovy Soup (7 servings)', recipes(:anchovy_soup).decorate.name_with_servings
  end

  test 'display_kcal' do
    assert_equal '54', recipes(:apple_pie).decorate.display_kcal
  end

  test 'display_carbs' do
    assert_equal '54', recipes(:apple_pie).decorate.display_carbs
  end

  test 'display_protein' do
    assert_equal '54', recipes(:apple_pie).decorate.display_protein
  end

  test 'display_fat' do
    assert_equal '54', recipes(:apple_pie).decorate.display_fat
  end

  test 'display_kcal_per_serving' do
    assert_equal '9', recipes(:apple_pie).decorate.display_kcal_per_serving
  end

  test 'display_carbs_per_serving' do
    assert_equal '9', recipes(:apple_pie).decorate.display_carbs_per_serving
  end

  test 'display_protein_per_serving' do
    assert_equal '9', recipes(:apple_pie).decorate.display_protein_per_serving
  end

  test 'display_fat_per_serving' do
    assert_equal '9', recipes(:apple_pie).decorate.display_fat_per_serving
  end
end
