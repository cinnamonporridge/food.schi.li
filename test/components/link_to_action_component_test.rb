require 'test_helper'

class LinkToActionComponentTest < ViewComponent::TestCase
  test 'render' do
    render_inline new_component('Link body', '/foo', icon: :pencil)
    assert_link 'Link body', href: '/foo'
    assert_selector 'svg.heroicons-pencil'
  end
end
