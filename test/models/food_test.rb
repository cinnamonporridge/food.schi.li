require 'test_helper'

class FoodTest < ActiveSupport::TestCase
  test 'creates default portion before create' do
    food = global_tomato

    assert food.save
    assert_equal 1, food.portions.count
    food.portions.first.tap do |portion|
      assert_equal '100g', portion.name
      assert_equal 100, portion.amount
    end
  end

  test 'updates data_source_updated_at when data_source_url changes, new record' do
    food = global_tomato
    food.data_source_url = 'https://nutrition-facts-source/'

    assert_changes -> { food.data_source_updated_at } do
      assert food.save!
      food.reload
    end
  end

  test 'does not update data_source_updated_at when data_source_url not changes, new record' do
    food = global_tomato

    assert_no_changes -> { food.data_source_updated_at } do
      assert food.save!
      food.reload
    end
  end

  test 'updates data_source_updated_at when data_source_url changes, existing record' do
    food = foods(:apple)

    assert_changes -> { food.data_source_updated_at } do
      assert food.update!(data_source_url: 'https://nutrition-facts-source/')
      food.reload
    end
  end

  test 'does not update data_source_updated_at when data_source_url not changes, existing record' do
    food = foods(:apple)

    assert_no_changes -> { food.data_source_updated_at } do
      assert food.update!(name: 'Apples!')
      food.reload
    end
  end

  test 'resets data_source_updated_at when data_source_url changes to blank' do
    food = foods(:apple)

    assert food.update!(data_source_url: 'https://nutrition-facts-source/')

    assert_changes -> { food.data_source_updated_at }, to: nil do
      assert food.update!(data_source_url: '')
      food.reload
    end
  end

  private

  def global_tomato
    users(:global).foods.new(name: 'Tomato', unit: 'gram',
                             kcal: 0, carbs: 0, carbs_sugar_part: 0, protein: 0,
                             fat: 0, fat_saturated: 0, fiber: 0)
  end
end
