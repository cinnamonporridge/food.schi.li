class VeganDetection::JournalDay
  def initialize(object)
    @object = object
  end

  def update!
    ActiveRecord::Base.connection.execute(update_sql)
  end

  private

  def update_sql
    <<~SQL.squish
      WITH journal_days_scope AS (
        SELECT jd.id                  AS journal_day_id
             , f.vegan                AS vegan
          FROM journal_days jd
          LEFT OUTER JOIN meals m             ON m.journal_day_id = jd.id
          LEFT OUTER JOIN meal_ingredients mi ON mi.meal_id = m.id
          LEFT OUTER JOIN portions p          ON p.id = mi.portion_id
          LEFT OUTER JOIN foods f             ON f.id = p.food_id
         WHERE 0 = 0
               #{filter_condition}
      )
      , non_vegan_journal_days AS (
        SELECT journal_day_id
             , count(*)                AS non_vegan_ingredients_count
          FROM journal_days_scope
         WHERE vegan = FALSE
      GROUP BY journal_day_id
      )
      , with_vegan_flag AS (
        SELECT jds.journal_day_id
             , CASE
                 WHEN nvjd.non_vegan_ingredients_count > 0 THEN FALSE
                 ELSE TRUE
               END AS vegan
          FROM journal_days_scope jds
         LEFT OUTER JOIN non_vegan_journal_days nvjd ON nvjd.journal_day_id = jds.journal_day_id
      )
      UPDATE journal_days jd
         SET vegan = target.vegan
        FROM with_vegan_flag target
       WHERE jd.id = target.journal_day_id
    SQL
  end

  def filter_condition
    return journal_day_filter if @object.is_a?(JournalDay)
    return food_filter if @object.is_a?(Food)
  end

  def journal_day_filter
    "AND jd.id = #{@object.id}"
  end

  def food_filter
    "AND f.id = #{@object.id}"
  end
end
