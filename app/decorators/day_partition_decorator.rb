class DayPartitionDecorator < SimpleDelegator
  def self.day_partition_options_for_user(user)
    user.day_partitions.not_defaults.ordered_by_position.map(&method(:to_option))
  end

  def self.to_option(day_partition)
    day_partition.decorate.to_option
  end

  def to_option
    ["#{position} - #{name}", id]
  end

  def display_name
    name unless default?
  end
end
