class DeleteButtonComponent < ViewComponent::Base
  attr_reader :body, :path, :icon, :button, :options

  BUTTONS_CSS_CLASSES = {
    dangerous: "dangerous-button",
    archive: "archive-button"
  }.freeze

  def initialize(body, path, icon: :trash, button: :dangerous, **options)
    @body = body
    @path = path
    @icon = icon
    @button = button
    @options = options
    super()
  end

  def css_classes
    "#{find_button_class} gap-x-1"
  end

  private

  def find_button_class
    BUTTONS_CSS_CLASSES[button]
  end
end
