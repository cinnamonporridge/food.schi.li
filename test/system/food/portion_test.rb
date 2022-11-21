require 'application_system_test_case'

class Food::PortionTest < ApplicationSystemTestCase
  test 'user adds a portion to own food' do
    sign_in_user :daisy
    navigate_to 'Foods'
    click_on 'Milk'
    click_on 'Add portion'

    assert_selector 'h1', text: 'New portion for Milk'
    assert_link 'Cancel', href: %r{/foods/[0-9]+}
    fill_in 'Name', with: 'Glass'
    fill_in 'Amount in g/ml', with: '200'
    click_on 'Add portion'

    assert_selector '.flash', text: 'Portion added'
    assert_selector 'ul.food--portions li', text: 'Glass'
  end

  test 'admin adds a portion to global food' do
    sign_in_user :daisy
    navigate_to 'Foods'
    click_on 'Apple'
    click_on 'Add portion'

    assert_selector 'h1', text: 'New portion for Apple'
    assert_link 'Cancel', href: %r{/foods/[0-9]+}
    fill_in 'Name', with: 'Tablespoon'
    fill_in 'Amount in g/ml', with: '25'
    click_on 'Add portion'

    assert_selector '.flash', text: 'Portion added'
    assert_selector 'ul.food--portions li', text: 'Tablespoon'
  end

  test 'non-admin cannot add a portion to global food' do
    sign_in_user :john
    navigate_to 'Foods'
    click_on 'Apple'

    assert_no_link 'Add portion'
  end

  test 'user edits a portion for own food' do
    sign_in_user :daisy
    navigate_to 'Foods'
    click_on 'Milk'
    within_portion 'Tablespoon' do
      assert_no_button 'Remove portion'
      click_on 'Edit portion'
    end

    assert_selector 'h1', text: 'Edit portion for Milk'
    assert_link 'Cancel', href: %r{/foods/[0-9]+}
    fill_in 'Name', with: 'Coffee spoon'
    fill_in 'Amount in g/ml', with: '5'
    click_on 'Update portion'

    assert_selector '.flash', text: 'Portion updated'
    within_portion 'Coffee spoon' do
      assert_text '5'
    end
  end

  test 'non-admin cannot edit a portion of global food' do
    sign_in_user :john
    navigate_to 'Foods'
    click_on 'Apple'
    within_portion 'Big Apple' do
      assert_no_button 'Remove portion'
      assert_no_link 'Edit portion'
    end
  end

  test 'admin edits a portion for global food' do
    sign_in_user :daisy
    navigate_to 'Foods'
    click_on 'Apple'
    within_portion 'Big Apple' do
      assert_no_button 'Remove portion'
      click_on 'Edit portion'
    end

    assert_selector 'h1', text: 'Edit portion for Apple'
    assert_link 'Cancel', href: %r{/foods/[0-9]+}
    fill_in 'Name', with: 'Large'
    fill_in 'Amount in g/ml', with: '175'
    click_on 'Update portion'

    assert_selector '.flash', text: 'Portion updated'
    within_portion 'Large' do
      assert_text '175'
    end
  end

  test 'user deletes a portion for own food' do
    food = foods(:milk)
    food.portions.create!(name: 'Coffee spoon', amount: 5)
    sign_in_user :daisy
    navigate_to 'Foods'
    click_on 'Milk'
    within_portion 'Coffee spoon' do
      click_on 'Remove portion'
    end

    assert_selector '.flash', text: 'Portion deleted'
    assert_selector 'ul.food--portions li', text: 'Small', count: 0
  end

  test 'admin deletes a portion for global food' do
    food = foods(:apple)
    food.portions.create!(name: 'Small', amount: 123)
    sign_in_user :daisy
    navigate_to 'Foods'
    click_on 'Apple'
    within_portion 'Small' do
      click_on 'Remove portion'
    end

    assert_selector '.flash', text: 'Portion deleted'
    assert_selector 'ul.food--portions li', text: 'Small', count: 0
  end

  test 'non-admin cannot delete a portion from global food' do
    food = foods(:apple)
    food.portions.create!(name: 'Small', amount: 123)
    sign_in_user :john
    navigate_to 'Foods'
    click_on 'Apple'

    within_portion 'Small' do
      assert_no_button 'Remove portion'
    end
  end

  private

  def within_portion(portion_name, &)
    within(find('ul.food--portions li', text: portion_name), &)
  end
end
