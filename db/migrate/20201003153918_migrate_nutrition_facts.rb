class MigrateNutritionFacts < ActiveRecord::Migration[6.0]
  def change
    NutritionFactsService.update_all
  end
end
