class FadeOutFlashComponent < ApplicationComponent
  attr_reader :text

  def initialize(text:)
    @text = text
    super()
  end

  def render?
    text.present?
  end
end
