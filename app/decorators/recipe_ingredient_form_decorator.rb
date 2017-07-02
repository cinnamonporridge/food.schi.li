class RecipeIngredientFormDecorator < Draper::Decorator
  delegate_all
  def unit_or_pieces_collection
    [['g/ml', 'unit'], ['Pieces', 'pieces']]
  end
end
