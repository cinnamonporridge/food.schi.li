module Searchable
  extend ActiveSupport::Concern

  included do
    scope :search, ->(query) {
      return if query.blank?

      where("UPPER(name) LIKE UPPER(:query)", query: "%#{query}%")
    }
  end
end
