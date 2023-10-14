require "application_system_test_case"

class Recipe::IngredientTest < ApplicationSystemTestCase
  test "user adds an ingredient to recipe" do
    sign_in_and_navigate_to_apple_pie_recipe
    click_link "Add ingredient"

    assert_selector "h1", text: "Add ingredient to Apple Pie"
    assert_link "Back", href: %r{/recipes/[0-9]+}

    search_food "Banana"

    within ".portions-select" do
      assert_checked_field "Banana 100"
      choose "Banana Regular"
    end

    click_button "Add recipe ingredient"

    assert_checked_field "Banana Regular" # selected value should remain

    fill_in "Amount in measure", with: "3"
    click_button "Add recipe ingredient"

    within_recipe_ingredient("Banana Regular") do
      assert_selector ".recipe-ingredient--quantity", text: "3"
      assert_selector ".recipe-ingredient--amount", text: "348"
    end
  end

  test "user adds an ingredient by searching first" do
    sign_in_and_navigate_to_apple_pie_recipe
    click_link "Add ingredient"

    search_food "apple"

    select_search_result "Pineapple"

    within ".portions-select" do
      assert_checked_field "Pineapple 100"
      choose "Pineapple Fruit"
    end

    fill_in "Amount in measure", with: "1"
    click_button "Add recipe ingredient"

    within_recipe_ingredient("Pineapple Fruit") do
      assert_selector ".recipe-ingredient--quantity", text: "1"
      assert_selector ".recipe-ingredient--amount", text: "905"
    end
  end

  test "portion measure-add-on changes depending on the selected radio button" do
    using_browser do
      sign_in_and_navigate_to_apple_pie_recipe
      click_link "Add ingredient"

      search_food "Banana"

      assert_checked_field "Banana 100"
      assert_selector ".portion-measure-add-on", text: "g/ml"

      choose("Banana Regular")

      assert_selector ".portion-measure-add-on", text: "Pieces"

      choose("Banana 100")

      assert_selector ".portion-measure-add-on", text: "g/ml"
    end
  end

  test "user changes food after submitting an invalid form" do
    sign_in_and_navigate_to_apple_pie_recipe
    click_link "Add ingredient"
    search_food "Banana"
    click_button "Add recipe ingredient"
    search_food "Apple"
    select_search_result "Apple"

    assert_checked_field "Apple 100" # checks if action_url works properly
  end

  test "user edits an ingredient in recipe" do
    using_browser do
      sign_in_and_navigate_to_apple_pie_recipe

      within_recipe_ingredient("Apple Big Apple") do
        assert_selector ".recipe-ingredient--name", text: "Apple Big Apple"
        assert_selector ".recipe-ingredient--quantity", text: "0.03"
        assert_selector ".recipe-ingredient--amount", text: "6"

        toggle_actions
        choose "Apple 100"
        fill_in "Amount in measure", with: "121"
        click_button "Update recipe ingredient"

        assert_selector ".recipe-ingredient--name", text: "Apple", exact_text: true
        assert_selector ".recipe-ingredient--quantity", text: ""
        assert_selector ".recipe-ingredient--amount", text: "121"
      end

      assert_totals_row_from_nutrition_table(
        kcal: "169",
        carbs: "169",
        protein: "169",
        fat: "169"
      )
    end
  end

  test "user deletes ingredient from recipe" do
    using_browser do
      sign_in_user :daisy
      navigate_to "Recipes"
      click_link "PB Bread"

      assert_totals_row_from_nutrition_table(
        recipe: recipes(:peanut_butter_bread),
        kcal: "96",
        carbs: "96",
        protein: "96",
        fat: "96"
      )

      within_recipe_ingredient "Whole Grain Bread Whole Grain Bread Portion" do
        toggle_actions
        click_button "Delete recipe ingredient"
        click_button "Confirm deletion"
      end

      assert_totals_row_from_nutrition_table(
        recipe: recipes(:peanut_butter_bread),
        kcal: "89",
        carbs: "89",
        protein: "89",
        fat: "89"
      )
    end
  end

  test "user deletes last ingredient from recipe" do
    recipe_ingredients(:apples_in_apple_pie).destroy! # only "Milk" left in this recipe

    using_browser do
      sign_in_and_navigate_to_apple_pie_recipe
      within_recipe_ingredient "Milk" do
        toggle_actions
        click_button "Delete recipe ingredient"
        click_button "Confirm deletion"
      end

      assert_selector "h1", text: "APPLE PIE"
      within ".recipe--header" do
        assert_selector ".vegan-badge"
      end
      assert_text "No ingredients = no nutritions"
    end
  end

  test "user deletes only non-vegan ingredient makes recipe vegan" do
    using_browser do
      sign_in_and_navigate_to_apple_pie_recipe

      within_recipe_ingredient "Milk" do
        toggle_actions
        click_button "Delete recipe ingredient"
        click_button "Confirm deletion"
      end

      assert_selector "h1", text: "APPLE PIE"
      within ".recipe--header" do
        assert_selector ".vegan-badge"
      end

      assert_selector ".nutritions-table"

      assert_totals_row_from_nutrition_table(
        kcal: "6",
        carbs: "6",
        protein: "6",
        fat: "6"
      )
    end
  end

  private

  def within_recipe_ingredient(ingredient_name, &)
    within(find("ul.recipe--ingredients li", text: ingredient_name), &)
  end

  def sign_in_and_navigate_to_apple_pie_recipe
    sign_in_user :daisy
    navigate_to "Recipes"
    click_link "Apple Pie"
  end

  def search_food(name)
    within ".food-search" do
      fill_in "Search food", with: name
      click_button "Search"
    end
  end

  def toggle_actions
    find("svg.heroicons-dots-vertical").ancestor("button").click
  end

  def assert_totals_row_from_nutrition_table(kcal:, carbs:, protein:, fat:, recipe: recipes(:apple_pie))
    within "##{dom_id(recipe, :nutritions_total)}" do
      assert_selector ".nutritions-table--totals--kcal", text: kcal
      assert_selector ".nutritions-table--totals--carbs", text: carbs
      assert_selector ".nutritions-table--totals--protein", text: protein
      assert_selector ".nutritions-table--totals--fat", text: fat
    end
  end

  def select_search_result(food_name)
    within "ul.food-search-result" do
      assert_selector "li", count: 2

      within(find("li .food-name", text: food_name, exact_text: true).ancestor("li")) do
        click_link "Select"
      end
    end
  end
end
