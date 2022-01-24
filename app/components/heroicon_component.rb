class HeroiconComponent < ViewComponent::Base
  attr_reader :icon

  def initialize(icon)
    @icon = icon
    super()
  end

  def icon_svg
    Rails.root.join('app/assets/images/heroicons/', icon.to_s).sub_ext('.svg').read
  end
end
