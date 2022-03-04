class CancelLinkComponent < ApplicationComponent
  attr_reader :href

  def initialize(href:)
    @href = href
    super()
  end
end
