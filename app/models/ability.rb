# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.blank?

    can :manage, Project, user_id: user.id
    can :manage, Task, user_id: user.id
  end
end
