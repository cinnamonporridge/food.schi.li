require 'test_helper'

class Buttons::ArchiveComponentTest < ViewComponent::TestCase
  test 'render' do
    render_inline Buttons::ArchiveComponent.new('Archive something', recipes(:apple_pie))
    assert_button 'Archive something'
    assert_selector 'form'
  end
end
