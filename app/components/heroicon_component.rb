class HeroiconComponent < ViewComponent::Base
  attr_reader :icon

  VALID_TAILWIND_CLASSES = %w[
    w-3 w-4
    h-3 h-4
  ].freeze

  def initialize(icon, square: 4)
    @icon = icon
    @width = square
    @height = square
    super()
  end

  def icon_svg
    Rails.root.join("app/assets/images/heroicons/", icon.to_s).sub_ext(".svg").read
  end

  def dimension_css_classes
    "#{width_css_class} #{heigth_css_class}"
  end

  private

  def width_css_class
    @width_css_class ||= validate_tailwind_css_class("w-#{@width}")
  end

  def heigth_css_class
    @heigth_css_class ||= validate_tailwind_css_class("h-#{@height}")
  end

  def validate_tailwind_css_class(css_class)
    VALID_TAILWIND_CLASSES.include?(css_class) ? css_class : (raise UnknownTailwindClass, css_class)
  end

  class UnknownTailwindClass < StandardError
    def initialize(css_class)
      super("Unknown Tailwind class: '#{css_class}'")
    end
  end
end
