class JournalDay < ApplicationRecord
  belongs_to :user

  has_many :meals, dependent: :destroy

  validates_presence_of :date
  validates_uniqueness_of :date, scope: :user

  scope :of, -> (user = User.none) { where(user: user) }
  scope :ordered_by_date, -> { order(date: :desc) }

  Nutrition::TYPES.each do |name|
    define_method :"sum_#{name}" do
      send(:sum_of_sustenance, name)
    end

    define_method(:"serving_#{name}") do
      send("sum_#{name}") / send(:servings)
    end
  end

  def sum_of_sustenance(name)
    meals.inject(0.0) { |sum, meal| sum += (meal.amount * meal.nutrition.send("#{name}")) / 100 }
  end

  def macronutrient_data
    @macronutrient_data_service ||= MacronutrientDataService.new(sum_carbs, sum_protein, sum_fat)
  end
end