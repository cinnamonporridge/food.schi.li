class VeganDetectionService
  def initialize(object)
    @object = object
  end

  def call!
    VeganDetection::Recipe.new(@object).call!
    VeganDetection::JournalDay.new(@object).call!
  end
end
