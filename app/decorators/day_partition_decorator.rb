class DayPartitionDecorator < SimpleDelegator
  def self.day_partition_options_for_user(user)
    user.day_partitions.not_defaults.ordered_by_position.map(&method(:to_option_with_id))
  end

  def self.move_to_position_options_for_user(user)
    user.day_partitions.not_defaults.ordered_by_position.map(&method(:to_option_with_position))
  end

  def self.to_option_with_id(day_partition)
    day_partition.decorate.to_option_with_id
  end

  def self.to_option_with_position(day_partition)
    day_partition.decorate.to_option_with_position
  end

  def to_option_with_id
    [option_label, id]
  end

  def to_option_with_position
    [option_label, position]
  end

  def option_label
    "#{position} - #{name}"
  end

  def display_name
    default? ? I18n.t("day_partition.unpartitioned") : name
  end
end
