require "test_helper"

class RecipeTest < ActiveSupport::TestCase
  test ".active, .archived, .archive" do
    assert_difference -> { Recipe.active.count }, -1 do
      assert_difference -> { Recipe.archived.count }, +1 do
        recipes(:apple_pie).archive
      end
    end
  end

  test ".active, .archived, .unarchive" do
    recipes(:apple_pie).archive

    assert_difference -> { Recipe.active.count }, +1 do
      assert_difference -> { Recipe.archived.count }, -1 do
        recipes(:apple_pie).unarchive
      end
    end
  end

  test ".search" do
    Recipe.search("An").tap do |result|
      assert_includes result, recipes(:anchovy_soup)
      assert_includes result, recipes(:vegan_peanut_butter_banana)
      assert_includes result, recipes(:non_vegan_milk_banana)
      assert_not_includes result, recipes(:apple_pie)
    end
  end
end
