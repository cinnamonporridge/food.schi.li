class NutritionFactsService
  VALID_TABLE_NAMES = %i[portions ingredients recipes meals journal_days].freeze

  def self.update_all
    VALID_TABLE_NAMES.map do |table_name|
      update(table_name)
    end
  end

  def self.update(*table_names)
    VALID_TABLE_NAMES & Array(table_names).each do |table_name|
      new.update(table_name)
    end
  end

  def update(table_name)
    raise InvalidArgument unless VALID_TABLE_NAMES.include?(table_name.to_sym)

    run(read_sql(table_name))
  end

  private

  def read_sql(table_name)
    Rails.root.join("lib/sql/update_nutrition_facts_on_#{table_name}.sql").read
  end

  def run(sql)
    ActiveRecord::Base.connection.execute(sql)
  end
end
