class JournalDayRecipeDecorator < SimpleDelegator
  def self.recipes_collection(user)
    recipes_collection_with_id(user).map(&:first)
  end

  def self.recipes_collection_with_id(user)
    user.recipes.ordered_by_name.map do |recipe|
      [recipe.decorate.name_with_servings, recipe.id]
    end
  end
end
