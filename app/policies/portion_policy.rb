class PortionPolicy < ApplicationPolicy
  delegate :read?, :write?, to: :food_policy

  def self.scope_for_user(user, name)
    PortionPolicy.new(user:).apply_scope(Portion.all, type: :active_record_relation, name:)
  end

  relation_scope(:read) do |scope|
    scope.where(food: authorized_scope(Food.all, as: :read))
  end

  relation_scope(:write) do |scope|
    scope.where(food: authorized_scope(Food.all, as: :write))
  end

  private

  def food_policy
    @food_policy ||= FoodPolicy.new(record.food, user:)
  end
end
