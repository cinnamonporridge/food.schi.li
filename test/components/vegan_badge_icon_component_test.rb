require 'test_helper'

class VeganBadgeIconComponentTest < ViewComponent::TestCase
  test '#render' do
    render_inline VeganBadgeIconComponent.new(true)
    assert_selector '.vegan-badge'
  end

  test 'not #render' do
    component = VeganBadgeIconComponent.new(false)
    assert_not component.render?
  end
end
