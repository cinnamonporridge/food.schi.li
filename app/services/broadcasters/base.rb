class Broadcasters::Base
  include ActionView::RecordIdentifier
  include Turbo::Streams::Broadcasts
  include Turbo::Streams::StreamName

  attr_reader :object, :event

  def initialize(object, event)
    @object = object
    @event = event
  end

  def broadcast
    send(:"broadcast_#{event}")
  end

  private

  def broadcast_replace_to_component(channel_name, component)
    broadcast_replace_to(
      channel_name,
      target: component.to_dom_id,
      html: ApplicationController.render(component, layout: false)
    )
  end
end
