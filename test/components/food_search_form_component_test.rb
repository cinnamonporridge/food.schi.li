require "test_helper"

class FoodSearchFormComponentTest < ViewComponent::TestCase
  test "#render, empty :food_name" do
    render_inline new_component(form: FoodSearchForm.new({ action_url: "foo" }, users(:daisy)))

    assert_not page.find_field("Search food").value.present?
  end

  test "#render, with :food_name" do
    render_inline new_component(form: FoodSearchForm.new({ action_url: "foo", food_name: "Mango" }, users(:daisy)))

    assert_field "Search food", with: "Mango"
  end

  test "#render, with search results" do
    with_request_url "/recipes/123/ingredients/new" do
      render_inline new_component(form: FoodSearchForm.new({ action_url: "foo", food_name: "na" }, users(:daisy)))

      assert_selector "ul.food-search-result li", count: 2
    end
  end
end
