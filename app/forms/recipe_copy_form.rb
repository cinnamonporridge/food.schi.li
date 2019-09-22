class RecipeCopyForm
  include ActiveModel::Model

  attr_reader :recipe, :name

  validates :name, presence: true

  def initialize(recipe, params = {})
    @recipe = recipe
    @name = params[:name]
  end

  def model_name
    ActiveModel::Name.new(nil, self, 'Recipe::Copy')
  end

  def new_recipe
    @new_recipe ||= RecipeCopyService.new(@recipe, name).copy
  end

  def save!
    return unless valid?

    new_recipe.save!
  end
end
