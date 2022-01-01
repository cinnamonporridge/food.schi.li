class JournalDayRecipeDecorator < SimpleDelegator
  def self.recipes_collection
    recipes_collection_with_id.map(&:first)
  end

  def self.recipes_collection_with_id
    Recipe.ordered_by_name.map do |recipe|
      [recipe.decorate.name_with_servings, recipe.id]
    end
  end
end
