require 'application_system_test_case'

class DayPartitionsTest < ApplicationSystemTestCase
  test 'displays day partitions' do
    sign_in_and_navigate_to_day_partitions

    assert_selector 'h1', text: 'Day partitions'
    assert_selector 'ul.day-partitions li', text: 'Breakfast'
  end

  test 'sees only own day partitions' do
    sign_in_and_navigate_to_day_partitions(:john)
    assert_selector 'ul.day-partitions li', text: 'Brunch'
    sign_out

    sign_in_and_navigate_to_day_partitions(:daisy)
    assert_selector 'ul.day-partitions li', text: 'Brunch', count: 0
  end

  test 'adds day partition' do
    sign_in_and_navigate_to_day_partitions

    click_on 'Add day partition'

    assert_selector 'h1', text: 'New day partition'

    within 'form.day-partition' do
      fill_in 'Name', with: 'Dinner'
      select 'At the end', from: 'Move to position'
      click_on 'Add day partition'
    end

    assert_selector '.flash', text: 'Day partition added'
    assert_selector 'ul.day-partitions li', text: 'Afternoon'
  end

  test 'edits day partition' do
    sign_in_and_navigate_to_day_partitions

    click_on 'Breakfast'

    assert_selector 'h1', text: 'Edit day partition'

    within 'form.day-partition' do
      fill_in 'Name', with: 'Morning'
      click_on 'Update day partition'
    end

    assert_selector '.flash', text: 'Day partition updated'
    assert_selector 'ul.day-partitions li', text: 'Morning'
  end

  test 'moves day partition to new position' do
    sign_in_and_navigate_to_day_partitions

    click_on 'Breakfast'

    assert_selector 'h1', text: 'Edit day partition'

    within 'form.day-partition' do
      fill_in 'Name', with: 'Snack between Lunch and Afternoon'
      select 'Afternoon', from: 'Move to position'
      click_on 'Update day partition'
    end

    assert_selector '.flash', text: 'Day partition updated'
    day_partition_list_elements = find_all('ul.day-partitions li')
    assert_match(/Lunch/, day_partition_list_elements[0].text)
    assert_match(/Snack between Lunch and Afternoon/, day_partition_list_elements[1].text)
    assert_match(/Afternoon/, day_partition_list_elements[2].text)
  end

  test 'deletes day partition' do
    sign_in_and_navigate_to_day_partitions

    click_on 'Breakfast'

    within '.day-partition--delete' do
      click_on 'Delete day partition'
    end

    assert_selector '.flash', text: 'Day partition deleted'
    assert_selector 'h1', text: 'Day partitions'
  end

  test 'deletes day partition is confirmable' do
    using_browser do
      sign_in_and_navigate_to_day_partitions

      click_on 'Breakfast'

      click_on 'Delete day partition'
      click_on 'Confirm deletion'

      assert_selector '.flash', text: 'Day partition deleted'
      assert_selector 'h1', text: 'Day partitions'
    end
  end

  private

  def sign_in_and_navigate_to_day_partitions(fixture_key = :daisy)
    sign_in_user fixture_key
    navigate_to 'Settings'
    click_on 'Day partitions'
  end
end
