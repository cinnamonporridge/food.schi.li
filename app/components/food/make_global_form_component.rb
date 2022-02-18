class Food::MakeGlobalFormComponent < ApplicationComponent
  attr_reader :food, :user

  def initialize(food:, user:)
    @food = food
    @user = user
    super()
  end

  def render?
    policy.make_global?
  end

  private

  def policy
    @policy ||= FoodPolicy.new(food, user:)
  end
end
