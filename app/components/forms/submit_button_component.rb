class Forms::SubmitButtonComponent < ViewComponent::Base
  attr_reader :object, :text, :heroicon

  def initialize(object:, text:, heroicon: nil)
    @object = object
    @text = text
    @heroicon = heroicon
  end

  def heroicon_component
    HeroiconComponent.new(find_heroicon)
  end

  private

  def find_heroicon
    heroicon || default_heroicon
  end

  def default_heroicon
    object.new_record? ? :'plus-sm' : :pencil
  end
end
