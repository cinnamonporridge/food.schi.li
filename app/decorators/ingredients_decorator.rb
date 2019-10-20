class IngredientsDecorator < Draper::CollectionDecorator
  def self.measures_collection
    [['g/ml', 'unit'], %w[Pieces piece]]
  end
end
