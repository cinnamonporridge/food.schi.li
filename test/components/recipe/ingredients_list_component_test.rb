require "test_helper"

class Recipe::IngredientsListComponentTest < ViewComponent::TestCase
  test "#render" do
    render_inline new_component(recipe: recipes(:apple_pie))

    assert_selector "ul.recipe--ingredients"
  end

  test "#to_dom_id" do
    component = new_component(recipe: recipes(:apple_pie))

    assert_match(/_ingredients_list$/, component.to_dom_id)
  end
end
