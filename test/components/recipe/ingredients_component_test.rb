require "test_helper"

class Recipe::IngredientsComponentTest < ViewComponent::TestCase
  test "#render" do
    render_inline new_component(recipe: recipes(:apple_pie))

    assert_selector "h2", text: "Ingredients"
    assert_text "6 servings"
    assert_selector "ul.recipe--ingredients"
  end
end
