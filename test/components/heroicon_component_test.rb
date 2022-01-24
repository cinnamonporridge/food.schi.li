require 'test_helper'

class HeroiconComponentTest < ViewComponent::TestCase
  test '#render' do
    render_inline HeroiconComponent.new(:pencil)
    assert_selector 'svg.heroicons-pencil'
  end

  test 'raises if icon does not exist' do
    error = assert_raises(Errno::ENOENT) { render_inline HeroiconComponent.new(:foo) }
    assert_match /^No such file or directory/, error.message
  end
end
