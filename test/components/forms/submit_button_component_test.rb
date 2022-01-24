require 'test_helper'

class Forms::SubmitButtonComponentTest < ViewComponent::TestCase
  test '#render, object is a new record' do
    render_inline Forms::SubmitButtonComponent.new(object: User.new, text: 'Add user')
    assert_selector 'svg.heroicons-plus-sm'
    assert_text 'Add user'
  end

  test '#render, object is persisted' do
    render_inline Forms::SubmitButtonComponent.new(object: users(:daisy), text: 'Update user')
    assert_selector 'svg.heroicons-pencil'
    assert_text 'Update user'
  end

  test '#render, custom icon' do
    render_inline Forms::SubmitButtonComponent.new(object: User.new, text: 'Delete user', heroicon: 'trash')
    assert_selector 'svg.heroicons-trash'
    assert_text 'Delete user'
  end
end
