class RecipeIngredientFormDecorator < Draper::Decorator
  delegate_all
  def measures_collection
    [['g/ml', 'unit'], ['Pieces', 'piece']]
  end
end
