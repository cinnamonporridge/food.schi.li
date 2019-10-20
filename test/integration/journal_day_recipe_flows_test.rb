require 'test_helper'

class JournalDayRecipeFlowsTest < ActionDispatch::IntegrationTest
  def setup
    login_user(users(:daisy))
    @february_first = journal_days(:daisy_february_first)
    @johns_journal_day = journal_days(:john_january_first)
  end

  test 'adds a recipe to a journal day' do
    get new_my_journal_day_recipe_path(@february_first)
    assert_response :success

    assert_select 'h1', 'Add recipe to journal day'

    post my_journal_day_recipes_path(@february_first), params: {
      journal_day_recipe: {
        recipe_name: '',
        servings: 0
      }
    }
    assert_response :success
    assert flash[:error].present?

    post my_journal_day_recipes_path(@february_first), params: {
      journal_day_recipe: {
        recipe_name: 'Anchovy Soup (7 servings)',
        servings: 3
      }
    }
    follow_redirect!
    assert_response :success

    assert_equal 'Recipe added', flash[:notice]
  end

  test 'daisy cannot add recipe to johns journal day' do
    get new_my_journal_day_recipe_path(@johns_journal_day)
    follow_redirect!
    assert_response :success

    assert_equal 'That journal day does not exist or does not belong to you', flash[:warning]

    post my_journal_day_recipes_path(@johns_journal_day), params: {
      journal_day_recipe: {
        recipe_name: 'Anchovy Soup (7 servings)',
        servings: 1
      }
    }
    follow_redirect!
    assert_response :success

    assert_equal 'That journal day does not exist or does not belong to you', flash[:warning]
  end
end
