class NutritionFactsService
  def promote_to_portions
    sql = Rails.root.join('lib/sql/update_nutrition_facts_on_portions.sql').read
    run(sql)
  end

  def promote_to_ingredients
    sql = Rails.root.join('lib/sql/update_nutrition_facts_on_ingredients.sql').read
    run(sql)
  end

  def promote_to_recipes
    sql = Rails.root.join('lib/sql/update_nutrition_facts_on_recipes.sql').read
    run(sql)
  end

  def promote_to_meals
    sql = Rails.root.join('lib/sql/update_nutrition_facts_on_meals.sql').read
    run(sql)
  end

  private

  def run(sql)
    ActiveRecord::Base.connection.execute(sql)
  end
end
