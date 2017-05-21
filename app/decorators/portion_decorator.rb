class PortionDecorator < Draper::Decorator
  def multiplier_in_gram_or_ml
    "#{(model.multiplier * 100)} g/ml"
  end
end
