class NutritionFacts::Base
  def initialize(user:)
    @user = user
  end

  def call!
    ActiveRecord::Base.connection.execute(update_sql)
  end
end
