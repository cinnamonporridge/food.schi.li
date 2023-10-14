class VeganDetection::Base
  def initialize(record)
    @record = record
  end

  def call!
    ActiveRecord::Base.connection.execute(update_sql) if can_run?
  rescue StandardError => e
    raise e.class, "\n\n*** Error appeared in #{self.class.name} ***\n\n#{e.message}"
  end

  private

  def can_run?
    model_to_column_filter_mapping.keys.include?(model.to_s.to_sym)
  end

  def model_to_column_filter_mapping
    raise "implement in subclass"
  end

  def filter
    "#{find_model_to_filter_column_mapping} IN (#{comma_separated_record_ids})"
  end

  def comma_separated_record_ids
    Array(@record).pluck(:id).join(", ") # rubocop:disable Rails/PluckId
  end

  def find_model_to_filter_column_mapping
    model_to_column_filter_mapping.fetch(model.name.to_sym)
  end

  def model
    Array(@record).first.class
  end
end
