require 'test_helper'
require 'rake'

class RecipeTest < ActiveSupport::TestCase
  setup do
    FoodSchiLi::Application.load_tasks if Rake::Task.tasks.empty?
  end

  teardown do
    Rake::Task.tasks.clear
  end

  test 'rake recipes:detect_and_set_vegan' do
    Recipe.update_all(vegan: false)

    assert_changes 'Recipe.where(vegan: true).count', from: 0 do
      Rake::Task['recipes:detect_and_set_vegan'].invoke
    end
  end
end
