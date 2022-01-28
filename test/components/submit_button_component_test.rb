require 'test_helper'

class SubmitButtonComponentTest < ViewComponent::TestCase
  test '#render with new object' do
    render_inline new_component('Add food', Food.new)
    assert_selector 'button[type=submit]'
    assert_text 'Add food'
    assert_selector 'svg.heroicons-plus-sm'
  end

  test '#render with persisted object' do
    render_inline new_component('Update food', foods(:apple))
    assert_selector 'button[type=submit]'
    assert_text 'Update food'
    assert_selector 'svg.heroicons-pencil'
  end

  test '#render with custom icon' do
    render_inline new_component('Copy thing', :duplicate)
    assert_selector 'button[type=submit]'
    assert_text 'Copy thing'
    assert_selector 'svg.heroicons-duplicate'
  end
end
