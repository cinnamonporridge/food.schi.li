class JournalDayRecipeForm
  include ActiveModel::Model

  attr_reader :journal_day, :recipe_name, :servings

  validates_numericality_of :servings, greater_than: 0

  validate :recipe_exists

  def initialize(journal_day, params = {})
    @journal_day = journal_day
    @recipe_name = params[:recipe_name]
    @servings = params[:servings] || 1
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'JournalDayRecipe')
  end

  def recipe
    @recipe ||= Recipe.find_by(id: recipe_id)
  end

  def recipe_id
    JournalDayRecipeDecorator.recipes_collection_with_id
                             .find { |form_recipe_name, _id| form_recipe_name == recipe_name }
                             &.last
  end

  private

  def recipe_exists
    errors.add(:recipe_name, 'Selected recipe does not exist') if recipe.nil?
  end
end
