class MacronutrientDataService
  ZERO = 0.0

  attr_reader :kcal, :carbs, :protein, :fat

  def initialize(data = {})
    @kcal     = data[:kcal] || ZERO
    @carbs    = data[:carbs] || ZERO
    @protein  = data[:protein] || ZERO
    @fat      = data[:fat] || ZERO
  end

  # value rounded
  def display_rounded_kcal
    kcal.to_f.round
  end

  def display_rounded_carbs
    carbs.to_f.round
  end

  def display_rounded_protein
    protein.to_f.round
  end

  def display_rounded_fat
    fat.to_f.round
  end
end
