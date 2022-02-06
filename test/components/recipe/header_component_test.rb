require 'test_helper'

class Recipe::HeaderComponentTest < ViewComponent::TestCase
  test '#render, no vegan' do
    render_inline new_component(recipe: recipes(:apple_pie))
    assert_selector 'h1', text: 'Apple Pie'
    assert_no_text 'Vegan'
    assert_link 'Edit recipe'
    assert_link 'Copy recipe'
    assert_button 'Archive recipe'
  end

  test '#render, vegan' do
    render_inline new_component(recipe: recipes(:vegan_peanut_butter_banana))
    assert_selector 'h1', text: 'Vegan Peanut Butter Banana'
    assert_selector '.vegan-badge'
    assert_text 'Vegan'
    assert_link 'Edit recipe'
    assert_link 'Copy recipe'
    assert_button 'Archive recipe'
  end
end
