class ApplicationForm
  include ActiveModel::Model

  attr_reader :object, :params

  delegate :id, :persisted?, :new_record?, to: :object

  def initialize(object, params = ActionController::Parameters.new)
    @object = object
    @params = params
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, name.sub(/Form$/, ''))
  end

  def save
    object.save || merge_errors_and_return_false!
  end

  def component_klass
    "#{self.class.name}Component".constantize
  end

  def form_component
    @form_component ||= component_klass.new(form: self)
  end

  private

  def merge_errors_and_return_false!
    errors.merge!(object.errors) && false
  end
end
