require "test_helper"

class HeroiconComponentTest < ViewComponent::TestCase
  test "#render, default dimension" do
    render_inline new_component(:pencil)

    assert_selector "svg.heroicons-pencil"
    assert_selector ".h-4.w-4"
  end

  test "#render, custom dimension" do
    render_inline new_component(:pencil, square: 3)

    assert_selector "svg.heroicons-pencil"
    assert_selector ".h-3.w-3"
  end

  test "raises if icon does not exist" do
    error = assert_raises(Errno::ENOENT) { render_inline new_component(:foo) }

    assert_match(/^No such file or directory/, error.message)
  end
end
