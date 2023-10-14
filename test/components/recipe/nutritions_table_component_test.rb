require "test_helper"

class Recipe::NutritionsTableComponentTest < ViewComponent::TestCase
  test "#render" do
    render_inline new_component(recipe: recipes(:apple_pie))

    assert_selector ".nutritions-table--header", count: 1
    assert_selector ".nutritions-table--recipe-ingredients", count: 1

    assert_selector ".nutritions-table--totals" do |element|
      title, kcal, carbs, protein, fat = element.find_all("div").to_a

      assert_equal "Total", title.text
      assert_equal "54", kcal.text
      assert_equal "54", carbs.text
      assert_equal "54", protein.text
      assert_equal "54", fat.text
    end

    assert_selector ".nutritions-table--totals-per-servings" do |element|
      title, kcal, carbs, protein, fat = element.find_all("div").to_a

      assert_equal "Per serving (1/6)", title.text.squish
      assert_equal "9", kcal.text
      assert_equal "9", carbs.text
      assert_equal "9", protein.text
      assert_equal "9", fat.text
    end
  end
end
