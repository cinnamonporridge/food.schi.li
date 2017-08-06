class IngredientsDecorator < Draper::CollectionDecorator
  def self.measures_collection
    [['g/ml', 'unit'], ['Pieces', 'piece']]
  end
end
