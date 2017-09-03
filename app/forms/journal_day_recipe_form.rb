class JournalDayRecipeForm
  include ActiveModel::Model

  attr_reader :journal_day, :recipe_id, :servings

  validates_numericality_of :servings, greater_than: 0

  validate :existence_of_recipe

  def initialize(journal_day, params = {})
    @journal_day  = journal_day
    @recipe_id    = params[:recipe_id]
    @servings     = params[:servings] || 1
  end

  def decorate
    JournalDayRecipeFormDecorator.new(self)
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'JournalDayRecipe')
  end

  def recipe
    @recipe ||= Recipe.find_by(id: recipe_id)
  end

  private

  def existence_of_recipe
    if recipe.nil?
      errors.add(:recipe_id, 'Selected recipe does not exist')
    end
  end
end
