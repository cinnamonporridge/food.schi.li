require 'test_helper'

class FoodDecoratorTest < ActiveSupport::TestCase
  test '#unit_abbrevation' do
    assert_equal 'g', Food.new(unit: 'gram').decorate.unit_abbrevation
    assert_equal 'ml', Food.new(unit: 'mililiter').decorate.unit_abbrevation
  end

  test '#units_collection' do
    units_collection = Food.new.decorate.units_collection
    assert_equal 2, units_collection.count
    assert_equal %w[Gram gram], units_collection.first
    assert_equal %w[Mililiter mililiter], units_collection.second
  end

  test '#display_kcal' do
    assert_equal '260', foods(:maple_syrup).decorate.display_kcal
  end

  test '#display_carbs' do
    assert_equal '67', foods(:maple_syrup).decorate.display_carbs
  end

  test '#display_protein' do
    assert_equal '0', foods(:maple_syrup).decorate.display_protein
  end

  test '#display_fat' do
    assert_equal '0', foods(:maple_syrup).decorate.display_fat
  end

  test '#data_source_url_authority' do
    food = Food.new(data_source_url: 'https://example.com/path/to/fact')
    assert_equal 'example.com', food.decorate.data_source_url_authority
  end
end
