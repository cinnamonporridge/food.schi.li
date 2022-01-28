class VeganDetection::Recipe
  def initialize(object)
    @object = object
  end

  def update!
    ActiveRecord::Base.connection.execute(update_sql)
  end

  private

  def update_sql
    <<~SQL.squish
      WITH recipes_scope AS (
        SELECT r.id                       AS recipe_id
             , f.vegan                    AS vegan
          FROM recipes r
          LEFT OUTER JOIN recipe_ingredients ri   ON ri.recipe_id = r.id
          LEFT OUTER JOIN portions p              ON p.id = ri.portion_id
          LEFT OUTER JOIN foods f                 ON f.id = p.food_id
         WHERE 0 = 0
               #{filter_condition}
      )
      , non_vegan_recipes AS (
        SELECT recipe_id
             , count(*)                   AS non_vegan_recipe_ingredients_count
          FROM recipes_scope
         WHERE vegan = FALSE
         GROUP BY recipe_id
      )
      , with_vegan_flag AS (
        SELECT rs.recipe_id
             , CASE
                 WHEN nvr.non_vegan_recipe_ingredients_count > 0 THEN FALSE
                 ELSE TRUE
               END AS vegan
          FROM recipes_scope rs
        LEFT OUTER JOIN non_vegan_recipes nvr ON nvr.recipe_id = rs.recipe_id
      )
      UPDATE recipes r
         SET vegan = target.vegan
        FROM with_vegan_flag target
       WHERE r.id = target.recipe_id
    SQL
  end

  def filter_condition
    return recipe_filter if @object.is_a?(Recipe)
    return food_filter if @object.is_a?(Food)
  end

  def recipe_filter
    "AND r.id = #{@object.id}"
  end

  def food_filter
    "AND f.id = #{@object.id}"
  end
end
