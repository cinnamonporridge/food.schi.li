class MacronutrientDataService
  attr_reader :carbs, :protein, :fat, :total

  def initialize(carbs, protein, fat)
    @carbs    = carbs
    @protein  = protein
    @fat      = fat
  end

  def display_carbs_percentage
    "#{carbs_percentage}%"
  end

  def display_protein_percentage
    "#{protein_percentage}%"
  end

  def display_fat_percentage
    "#{fat_percentage}%"
  end

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
    return 0.0 unless total.positive?
    ((carbs / total) * 100.0)
  end

  def protein_percentage
    return 0.0 unless total.positive?
    ((protein / total) * 100)
  end

  def fat_percentage
    return 0.0 unless total.positive?
    ((fat / total) * 100)
  end
end
