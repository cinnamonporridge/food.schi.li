require "test_helper"

class JournalDayRecipeDecoratorTest < ActiveSupport::TestCase
  test ".recipes_collection" do
    JournalDayRecipeDecorator.recipes_collection(users(:daisy)).tap do |recipes_collection|
      assert_equal 6, recipes_collection.count
      assert_equal "Anchovy Soup (7 servings)", recipes_collection.first
      assert_equal "Vegan Peanut Butter Banana (1 serving)", recipes_collection.last
    end
  end

  test ".recipes_collection_with_id" do
    JournalDayRecipeDecorator.recipes_collection_with_id(users(:daisy)).tap do |recipes_collection|
      assert_equal 6, recipes_collection.count
      assert_equal ["Anchovy Soup (7 servings)", recipes(:anchovy_soup).id],
                   recipes_collection.first
      assert_equal ["Vegan Peanut Butter Banana (1 serving)", recipes(:vegan_peanut_butter_banana).id],
                   recipes_collection.last
    end
  end
end
