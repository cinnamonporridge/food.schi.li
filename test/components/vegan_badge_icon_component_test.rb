require "test_helper"

class VeganBadgeIconComponentTest < ViewComponent::TestCase
  test "#render" do
    render_inline new_component(true)

    assert_selector ".vegan-badge"
  end

  test "not #render" do
    component = new_component(false)

    assert_not component.render?
  end
end
