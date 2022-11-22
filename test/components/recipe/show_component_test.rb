require 'test_helper'

class Recipe::ShowComponentTest < ViewComponent::TestCase
  test '#render' do
    render_inline new_component(recipe: recipes(:apple_pie))

    assert_selector 'h1', text: 'Apple Pie'
    assert_selector 'h2', text: 'Nutritions'
    assert_selector 'h2', text: 'Ingredients'
  end
end
