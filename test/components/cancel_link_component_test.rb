require 'test_helper'

class CancelLinkComponentTest < ViewComponent::TestCase
  test '#render' do
    render_inline new_component(href: '/foo')

    assert_link 'Cancel', href: '/foo'
  end
end
