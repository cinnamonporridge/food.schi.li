class NutrientLabelsComponent < ViewComponent::Base
  DECORATOR_METHODS = {
    kcal: {
      default: :display_kcal,
      per_serving: :display_kcal_per_serving
    },
    carbs: {
      default: :display_carbs,
      per_serving: :display_carbs_per_serving
    },
    protein: {
      default: :display_protein,
      per_serving: :display_protein_per_serving
    },
    fat: {
      default: :display_fat,
      per_serving: :display_fat_per_serving
    }
  }.freeze

  def initialize(object:, per_serving: false)
    @object = object
    @decorator_values = per_serving ? :per_serving : :default
    super()
  end

  def kcal
    display_value(:kcal)
  end

  def carbs
    display_value(:carbs)
  end

  def protein
    display_value(:protein)
  end

  def fat
    display_value(:fat)
  end

  private

  def decorated_object
    @decorated_object ||= @object.decorate
  end

  def display_value(nutrition)
    decorated_object.send(find_decorator_method(nutrition).to_sym)
  end

  def find_decorator_method(nutrition)
    DECORATOR_METHODS.dig(nutrition, @decorator_values)
  end
end
