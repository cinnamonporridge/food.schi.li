require 'test_helper'

class RecipeIngredient::ListItem::HeadComponentTest < ViewComponent::TestCase
  test '#render' do
    render_inline new_component(recipe_ingredient: recipe_ingredients(:apples_in_apple_pie))
    assert_selector '.recipe-ingredient--name', text: 'Apple Big Apple' do
      assert_selector '.vegan-badge'
    end
    assert_selector '.recipe-ingredient--quantity', text: '0.03'
    assert_selector '.recipe-ingredient--amount', text: '6'
  end

  test '#to_dom_id' do
    component = new_component(recipe_ingredient: recipe_ingredients(:apples_in_apple_pie))
    assert_match(/_list_item_head$/, component.to_dom_id)
  end
end
