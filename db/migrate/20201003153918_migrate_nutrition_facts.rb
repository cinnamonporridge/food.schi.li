class MigrateNutritionFacts < ActiveRecord::Migration[6.0]
  def change
    NutritionFactsService.update_all if Time.zone.today.year == 2020
  end
end
