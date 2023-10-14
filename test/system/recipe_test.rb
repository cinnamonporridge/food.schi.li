require "application_system_test_case"

class RecipeTest < ApplicationSystemTestCase
  test "user adds a recipe" do
    sign_in_user :daisy
    navigate_to "Recipes"
    click_link "Add recipe"

    assert_selector "h1", text: "New recipe"
    assert_link "Cancel", href: "/recipes"
    fill_in "Name", with: "Tomato soup"
    fill_in "Servings", with: "3"
    click_button "Add recipe"

    assert_selector ".flash", text: "Recipe added"
    assert_selector "h1", text: "Tomato soup"
  end

  test "user edits a recipe" do
    using_browser do
      sign_in_user :daisy
      navigate_to "Recipes"
      click_link "Apple Pie"

      within_recipe_menu do
        click_link "Edit recipe"
      end

      assert_selector "h1", text: "Edit Apple Pie"
      assert_link "Cancel", href: %r{/recipes/[0-9]+}
      fill_in "Name", with: "Apple Cake"
      fill_in "Servings", with: "2"
      click_button "Update recipe"

      assert_selector ".flash", text: "Recipe updated"
      assert_selector "h1", text: "APPLE CAKE"
    end
  end

  test "user archives a recipe" do
    sign_in_user :daisy
    navigate_to "Recipes"
    click_link "Anchovy Soup"
    click_button "Archive recipe"

    assert_selector ".flash", text: "Recipe archive"
    assert_selector "h1", text: "Recipes"
    assert_no_link "Anchovy Soup"
  end

  test "user unarchives a recipe" do
    recipe = recipes(:anchovy_soup)
    recipe.archive

    sign_in_user :daisy
    visit recipe_path(recipe) # archived are NOT reachable without knowing the path

    assert_text "Archived"
    assert_no_link "Edit"
    assert_no_link "Copy"
    assert_no_link "Remove"
    assert_no_link "Add"
    click_button "Unarchive recipe"

    assert_selector ".flash", text: "Recipe unarchived"
    assert_selector "h1", text: "Anchovy Soup"
    assert_no_text "Archived"
  end

  test "user copies a recipe" do
    sign_in_user :daisy
    navigate_to "Recipes"
    click_link "PB Bread"

    assert_selector "h1", text: "PB Bread"
    click_link "Copy recipe"

    assert_selector "h1", text: "Copy PB Bread"
    assert_link "Cancel", href: %r{/recipes/[0-9]+}
    click_button "Copy recipe"

    assert_text "can't be blank"
    fill_in "New recipe name", with: "PB&J Version 1"
    click_button "Copy recipe"

    assert_selector "h1", text: "PB&J Version 1"
  end

  private

  def within_recipe_menu(&)
    within ".recipe--header" do
      click_button "Toggle menu"
      yield
    end
  end
end
