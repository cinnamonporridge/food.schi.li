require 'test_helper'

class DeleteButtonComponentTest < ViewComponent::TestCase
  test '#render' do
    render_inline DeleteButtonComponent.new('Delete text', '/foo')
    assert_selector 'form'
    assert_button 'Delete text'
    assert_selector 'svg.heroicons-trash'
  end

  test '#render, custom icon and different button' do
    render_inline DeleteButtonComponent.new('Delete text', '/foo', icon: :archive, button: :archive)
    assert_selector 'form'
    assert_button 'Delete text'
    assert_selector 'svg.heroicons-archive'
    assert_selector '.archive-button'
  end
end
