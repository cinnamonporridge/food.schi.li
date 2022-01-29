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

  # percentage exact
  def display_carbs_percentage
    "#{carbs_percentage}%"
  end

  def display_protein_percentage
    "#{protein_percentage}%"
  end

  def display_fat_percentage
    "#{fat_percentage}%"
  end

  # percentage rounded
  def display_rounded_carbs_percentage
    "#{carbs_percentage.round}%"
  end

  def display_rounded_protein_percentage
    "#{protein_percentage.round}%"
  end

  def display_rounded_fat_percentage
    "#{fat_percentage.round}%"
  end

  private

  def total
    @total ||= (carbs + protein + fat)
  end

  def carbs_percentage
    @carbs_percentage ||= percentage_of_value(carbs)
  end

  def protein_percentage
    @protein_percentage ||= percentage_of_value(protein)
  end

  def fat_percentage
    @fat_percentage ||= percentage_of_value(fat)
  end

  def percentage_of_value(value)
    return ZERO if total.zero?

    ((value / total) * 100.0)
  end
end
