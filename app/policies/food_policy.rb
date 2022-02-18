class FoodPolicy < ApplicationPolicy
  def self.scope_for_user(user, name)
    FoodPolicy.new(user:).apply_scope(Food.all, type: :active_record_relation, name:)
  end

  def read?
    true
  end

  def write?
    admin?
  end

  def make_global?
    admin? && !record.global?
  end

  relation_scope :read do |relation|
    relation.of_user_or_global(user)
  end

  relation_scope :write do |relation|
    if admin?
      relation.of_user_or_global(user)
    else
      relation.of_user(user)
    end
  end

  private

  def admin?
    user.role_admin?
  end
end
