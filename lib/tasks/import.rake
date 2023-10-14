# rubocop:disable Metrics/BlockLength
require "csv"

namespace :import do
  desc "Import FDC"
  task fdc: :environment do
    global_user = User.find_global_user
    foods_file_path = Rails.root.join("db/data/fdc/foods.csv")

    CSV.table(foods_file_path).each do |row|
      food = global_user.foods.find_or_initialize_by(data_source_url: row[:data_source_url])
      food.assign_attributes(
        name: row[:name],
        kcal: row[:kcal].to_i,
        carbs: row[:carbs].to_f,
        carbs_sugar_part: row[:carbs_sugar_part].to_f,
        protein: row[:protein].to_f,
        fat: row[:fat].to_f,
        fat_saturated: row[:fat_saturated].to_f,
        fiber: row[:fiber].to_f
      )
      food.save!
    end

    portions_file_path = Rails.root.join("db/data/fdc/portions.csv")

    CSV.table(portions_file_path).each do |row|
      food = global_user.foods.find_by!(data_source_url: row[:data_source_url])
      portion = food.portions.find_or_initialize_by(name: row[:portion_name])

      portion.assign_attributes(amount: row[:amount].to_i)
      portion.save!
    rescue StandardError => _e
      puts "Food not found: #{row[:food_name]} (#{row[:data_source_url]})"
    end

    NutritionFacts::Portions.new(global_user).call!
  end
end
# rubocop:enable Metrics/BlockLength
