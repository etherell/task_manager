# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, Project, user_id: user.id if user.present?
  end
end
