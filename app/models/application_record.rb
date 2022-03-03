class ApplicationRecord < ActiveRecord::Base
  include Decoratable
  self.abstract_class = true

  def self.human_enum_name(enum_name, enum_value)
    enum_translations(enum_name)[enum_value.to_sym]
  end

  def self.enum_translations(enum_name)
    I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}")
  end
end
