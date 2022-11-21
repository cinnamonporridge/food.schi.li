require 'test_helper'

class NutrientLabelsComponentTest < ViewComponent::TestCase
  test '#render, per_serving: false' do
    render_inline new_component(object: recipes(:apple_pie))

    assert_selector '.stats-kcal', text: '54'
    assert_selector '.stats-carbs', text: '54'
    assert_selector '.stats-protein', text: '54'
    assert_selector '.stats-fat', text: '54'
  end

  test '#render, per_serving: true' do
    render_inline new_component(object: recipes(:apple_pie), per_serving: true)

    assert_selector '.stats-kcal', text: '9'
    assert_selector '.stats-carbs', text: '9'
    assert_selector '.stats-protein', text: '9'
    assert_selector '.stats-fat', text: '9'
  end
end
