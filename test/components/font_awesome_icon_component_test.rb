require 'test_helper'

class FontAwesomeIconComponentTest < ViewComponent::TestCase
  test '#render' do
    render_inline FontAwesomeIconComponent.new(:'seedling-light')
    assert_selector 'svg.fa-seedling'
  end

  test 'raises if icon does not exist' do
    error = assert_raises(Errno::ENOENT) { render_inline FontAwesomeIconComponent.new(:foo) }
    assert_match(/^No such file or directory/, error.message)
  end
end
