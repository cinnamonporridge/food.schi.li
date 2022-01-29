class HeroiconComponent < ViewComponent::Base
  attr_reader :icon

  def initialize(icon, square: 4)
    @icon = icon
    @width = square
    @height = square
    super()
  end

  def icon_svg
    Rails.root.join('app/assets/images/heroicons/', icon.to_s).sub_ext('.svg').read
  end

  def dimension_css_classes
    "#{width_css_class} #{heigth_css_class}"
  end

  private

  def width_css_class
    "w-#{@width}"
  end

  def heigth_css_class
    "h-#{@height}"
  end
end
