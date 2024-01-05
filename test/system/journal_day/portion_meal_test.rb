require "application_system_test_case"

class JournalDay::PortionMealTest < ApplicationSystemTestCase
  setup do
    @journal_day = journal_days(:daisy_february_first)
  end

  test "user adds a portion to journal day" do
    sign_in_user :daisy
    click_link "01.02.2017"

    click_link "Add portion meal"
    select "Peanut Butter (100g)", from: "Portion"
    fill_in "Amount in measure", with: "50"
    select "g/ml", from: "Measure"
    click_button "Add portion meal"

    assert_selector "h1", text: "Wed, 01.02.2017"
    assert_selector ".portion-meals li", text: "Peanut Butter"
  end

  test "user edits a portion on journal day" do
    sign_in_user :daisy
    click_link "01.02.2017"

    within "li.portion-meal", text: "Apple Big Apple" do
      click_link "Edit meal"
    end

    fill_in "Amount in measure", with: "5"
    click_button "Edit portion meal"

    assert_selector "h1", text: "Wed, 01.02.2017"
    within "li.portion-meal", text: "Apple Big Apple" do
      assert_selector ".portion-meal--amount", text: "1000"
      assert_selector ".portion-meal--quantity", text: "5"
    end
  end

  test "user deletes a portion from journal day" do
    sign_in_user :daisy
    click_link "01.02.2017"

    within "li.portion-meal", text: "Apple Big Apple" do
      click_button "Remove meal"
    end

    assert_selector "h1", text: "Wed, 01.02.2017"
    assert_selector ".flash", text: "Meal deleted"
    assert_selector "li.portion-meal", text: "Apple Big Apple", count: 0
  end
end
