require 'test_helper'

class JournalDayRecipeFlowsTest < ActionDispatch::IntegrationTest

  def setup
    login_user(users(:daisy))
    @february_first = journal_days(:daisy_february_first)
  end

  test 'adds a recipe to a journal day' do
    recipe = recipes(:anchovy_soup)
    get new_my_journal_day_recipe_path(@february_first)
    assert_response :success

    assert_select 'h1', 'Add recipe to journal day'

    post my_journal_day_recipes_path(@february_first), params: {
      journal_day_recipe: {
        recipe_id: '',
        servings: 0
      }
    }
    assert_response :success
    assert flash[:error].present?

    post my_journal_day_recipes_path(@february_first), params: {
      journal_day_recipe: {
        recipe_id: recipe.id,
        servings: 3
      }
    }
    follow_redirect!
    assert_response :success

    assert_equal 'Recipe added', flash[:notice]
  end
end
