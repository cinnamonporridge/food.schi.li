namespace :recipes do
  desc 'Detect and set vegan recipes'
  task detect_and_set_vegan: :environment do
    Recipe.all.each do |recipe|
      recipe.detect_vegan
      recipe.save
    end
  end
end
