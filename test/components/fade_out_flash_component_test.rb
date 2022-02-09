require 'test_helper'

class FadeOutFlashComponentTest < ViewComponent::TestCase
  test '#render' do
    render_inline new_component(text: 'Something happened')
    assert_text 'Something happened'
    assert_selector '.fade-out'
  end

  test 'not #render, text blank' do
    component = new_component(text: '')
    assert_not component.render?
  end
end
