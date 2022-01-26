class VeganBadgeIconComponent < ViewComponent::Base
  attr_reader :vegan

  def initialize(vegan)
    @vegan = vegan
    super()
  end

  def render?
    vegan
  end
end
