module Decoratable
  extend ActiveSupport::Concern

  def decorate
    @decorate ||= "#{self.class.name}Decorator".constantize.new(self)
  end
end
