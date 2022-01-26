class VeganDetectionService
  def initialize(object = :all)
    @object = object
  end

  def update_all!
    update_recipes!
    update_journal_days!
  end

  private

  def update_recipes!
    VeganDetection::Recipe.new(@object).update! if all? || @object.is_a?(Food) || @object.is_a?(Recipe)
  end

  def update_journal_days!
    VeganDetection::JournalDay.new(@object).update! if all? || @object.is_a?(Food) || @object.is_a?(JournalDay)
  end

  def all?
    @object == :all
  end
end
