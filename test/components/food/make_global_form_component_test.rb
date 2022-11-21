require 'test_helper'

class Food::MakeGlobalFormComponentTest < ViewComponent::TestCase
  test '#render' do
    render_inline new_component(food: foods(:milk), user: users(:daisy))

    assert_button 'Make food global'
  end

  test 'not #render' do
    component = new_component(food: foods(:maple_syrup), user: users(:john))

    assert_not component.render?
  end
end
