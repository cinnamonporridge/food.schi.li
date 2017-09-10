class JournalDayRecipeFormDecorator < Draper::Decorator
  delegate_all

  def recipes_collection
    Recipe.ordered_by_name.map do |recipe|
      [
        recipe.decorate.name_with_servings,
        recipe.id
      ]
    end
  end
end
