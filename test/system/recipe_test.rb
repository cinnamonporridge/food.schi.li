require 'application_system_test_case'

class RecipeTest < ApplicationSystemTestCase
  test 'admin copies a recipe' do
    recipe = recipes(:peanut_butter_bread)
    sign_in_user(users(:daisy))

    visit recipe_path(recipe)

    assert_selector 'h1', text: 'PB Bread'

    click_on 'Copy'

    assert_selector 'h1', text: 'Copy PB Bread'
    assert_selector 'a', text: 'Cancel'

    click_on 'Copy recipe'

    assert_selector '[aria-invalid=true]', count: 1

    fill_in 'New recipe name', with: 'PB&J Version 1'

    click_on 'Copy recipe'

    assert_selector 'h1', text: 'PB&J Version 1'
  end
end
