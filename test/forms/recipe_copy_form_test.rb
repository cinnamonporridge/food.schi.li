require "test_helper"

class RecipeCopyFormTest < ActiveSupport::TestCase
  attr_reader :recipe

  setup do
    @recipe = recipes(:peanut_butter_bread)
  end

  test "invalid form" do
    form = RecipeCopyForm.new(recipe, name: "")

    assert_not form.valid?
    assert_not form.save!
  end

  test "valid form" do
    form = RecipeCopyForm.new(recipe, name: "Recipe Copy")

    assert_predicate form, :valid?
    assert form.save!
  end
end
