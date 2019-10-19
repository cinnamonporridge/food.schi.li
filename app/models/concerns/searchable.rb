module Searchable
  extend ActiveSupport::Concern

  included do
    scope :search, ->(query) {
      return unless query.present?

      where('UPPER(name) LIKE UPPER(:query)', query: "%#{query}%")
    }
  end
end
