# encoding: utf-8

class Ability
  include CanCan::Ability

  def initialize(user)
    # TODO: TMP-DEVISE-DEACTIVATION - use the original code below
    can :manage, :all
=begin
    if user.present? and user.is_admin?
      can :manage, :all
    else
      #
      # Sem Apps
      #
      can :read, SemApp do |sem_app|
        sem_app.approved? or (user.present? and user.owns_sem_app?(sem_app))
      end

      can :create, SemApp do |sem_app|
        user.present?
      end

      can :edit, SemApp do |sem_app|
        user.present? and user.owns_sem_app?(sem_app) and not sem_app.archived
      end
    end
=end
  end
end
