class NutritionFactsService
  def promote_to_portions
    sql = Rails.root.join('lib/sql/update_nutrition_facts_on_portions.sql').read
    Portion.connection.execute(sql)
  end

  def promote_to_ingredients
    sql = Rails.root.join('lib/sql/update_nutrition_facts_on_ingredients.sql').read
    Portion.connection.execute(sql)
  end

  def promote_to_recipes
    sql = Rails.root.join('lib/sql/update_nutrition_facts_on_recipes.sql').read
    Portion.connection.execute(sql)
  end
end
