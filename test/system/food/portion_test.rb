require 'application_system_test_case'

class Food::PortionTest < ApplicationSystemTestCase
  test 'user adds a portion to food' do
    sign_in_user :daisy
    navigate_to 'Foods'
    click_on 'Milk'
    click_on 'Add portion'
    assert_selector 'h1', text: 'New portion for Milk'
    assert_link 'Cancel', href: %r{/foods/[0-9]+}
    fill_in 'Name', with: 'Tablespoon'
    fill_in 'Amount in g/ml', with: '25'
    click_on 'Add portion'
    assert_selector '.flash', text: 'Portion added'
    assert_selector 'ul.food--portions li', text: 'Tablespoon'
  end

  test 'user edits a portion for food' do
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

  test 'user deletes a portion for food' do
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

  private

  def within_portion(portion_name, &)
    within(find('ul.food--portions li', text: portion_name), &)
  end
end
