require 'test_helper'

class LinkToActionComponentTest < ViewComponent::TestCase
  test 'render' do
    render_inline new_component('Link body', '/foo', icon: :pencil, 'data-turbo': false)

    assert_link 'Link body', href: '/foo' do |element|
      assert_equal 'false', element['data-turbo']
    end

    assert_selector 'svg.heroicons-pencil'
  end
end
