class JournalDay::NutritionsTableComponent < ViewComponent::Base
  attr_reader :journal_day

  def initialize(journal_day:)
    @journal_day = journal_day
    super()
  end

  def format(number)
    number_with_delimiter(number.round, delimiter: "'")
  end
end
