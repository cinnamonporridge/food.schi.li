class SubmitButtonComponent < ViewComponent::Base
  attr_reader :text

  def initialize(text, object_or_icon_key)
    @text = text
    @object_or_icon_key = object_or_icon_key
    super()
  end

  def icon_key
    find_icon_key
  end

  private

  def find_icon_key
    @object_or_icon_key.respond_to?(:new_record?) ? add_or_edit_icon : @object_or_icon_key
  end

  def add_or_edit_icon
    @object_or_icon_key.new_record? ? :'plus-sm' : :pencil
  end
end
