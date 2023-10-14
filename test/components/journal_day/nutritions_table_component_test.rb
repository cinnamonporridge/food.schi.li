require "test_helper"

class JournalDay::NutritionsTableComponentTest < ViewComponent::TestCase
  test "#render" do
    render_inline new_component(journal_day: journal_days(:daisy_february_fifth))
    total, kcal, carbs, protein, fat = page.find_all(".journal-day--nutritions-table--total div").to_a

    assert_equal "Total", total.text
    assert_equal "54", kcal.text
    assert_equal "54", carbs.text
    assert_equal "54", protein.text
    assert_equal "54", fat.text
  end
end
