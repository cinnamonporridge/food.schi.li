require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  test 'search' do
    Recipe.search('An').tap do |result|
      assert_includes result, recipes(:anchovy_soup)
      assert_includes result, recipes(:vegan_peanut_butter_banana)
      assert_includes result, recipes(:non_vegan_milk_banana)
      assert_not_includes result, recipes(:apple_pie)
    end
  end
end
