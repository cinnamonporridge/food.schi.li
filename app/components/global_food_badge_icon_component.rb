class GlobalFoodBadgeIconComponent < ApplicationComponent
  attr_reader :global

  def initialize(global)
    @global = global
    super()
  end

  def render?
    global
  end
end
