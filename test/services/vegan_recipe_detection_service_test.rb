require 'test_helper'

class VeganRecipeDetectionServiceTest < ActiveSupport::TestCase
  test 'detects vegan recipe' do
    vegan_recipe = recipes(:vegan_peanut_butter_banana)
    service = VeganRecipeDetectionService.new(vegan_recipe)
    assert service.vegan?, 'Vegan recipe should be detected to be vegan'
  end

  test 'detects non-vegan recipe' do
    non_vegan_recipe = recipes(:non_vegan_milk_banana)
    service = VeganRecipeDetectionService.new(non_vegan_recipe)
    assert_not service.vegan?, 'Non vegan recipe should be detected to be non-vegan'
  end
end
