class Buttons::ArchiveComponent < ViewComponent::Base
  attr_reader :button_text, :object

  def initialize(button_text, object)
    @button_text = button_text
    @object = object
    super()
  end
end
