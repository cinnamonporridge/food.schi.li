require 'csv'

namespace :import do
  desc 'Import foods.csv'
  task foods: :environment do
    foods_file_path = Rails.root.join('db/foods.csv')
    CSV.foreach(foods_file_path) do |row|
      next if row[0] == 'name'

      food = Food.find_or_create_by(name: row[0])
      food.update(
        kcal: row[1].to_i,
        carbs: row[2].to_f,
        carbs_sugar_part: row[3].to_f,
        protein: row[4].to_f,
        fat: row[5].to_f,
        fat_saturated: row[6].to_f,
        fiber: row[7].to_f
      )
      default_portion = food.portions.find_or_initialize_by(amount: 100)
      default_portion.name ||= '100g'
      food.save!
    end
  end
end
