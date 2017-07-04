require 'csv'

namespace :import do
  desc 'Import nutritions.csv'
  task nutritions: :environment do
    nutritions_file_path = Rails.root.join('db/data/nutritions.csv')
    CSV.foreach(nutritions_file_path) do |row|
      next if row[0] == 'name'
      nutrition = Nutrition.find_or_create_by(name: row[0])
      nutrition.update(
        kcal: row[1].to_i,
        carbs: row[2].to_f,
        carbs_sugar_part: row[3].to_f,
        protein: row[4].to_f,
        fat: row[5].to_f,
        fat_saturated: row[6].to_f,
        fiber: row[7].to_f
      )
      default_portion = nutrition.portions.find_or_initialize_by(amount: 100)
      default_portion.name ||= '100g'
      nutrition.save!
    end
  end
end
