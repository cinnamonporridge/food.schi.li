module Archiveable
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where(archived_at: nil) }
    scope :archived, -> { where.not(archived_at: nil) }
  end

  def active?
    archived_at.nil?
  end

  def archived?
    archived_at.present?
  end

  def archive
    update(archived_at: Time.zone.now)
  end

  def unarchive
    update(archived_at: nil)
  end
end
