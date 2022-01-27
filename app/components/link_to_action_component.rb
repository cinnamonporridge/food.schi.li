class LinkToActionComponent < ViewComponent::Base
  attr_reader :body, :path, :icon, :button

  BUTTONS_CSS_CLASSES = {
    primary: 'button',
    secondary: 'secondary-button',
    gray_dashed: 'gray-dashed-button'
  }.freeze

  def initialize(body, path, icon:, button: :primary)
    @body = body
    @path = path
    @icon = icon
    @button = button
    super()
  end

  def css_classes
    "#{button_css_classes} gap-x-1"
  end

  private

  def button_css_classes
    BUTTONS_CSS_CLASSES[button]
  end
end
