class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.is_admin?
      can :manage, :all
    else
      #
      # Sem Apps
      #
      can :read, SemApp do |sem_app|
        sem_app.approved? || sem_app.owned_by?(user)
      end

      can :create, SemApp do |sem_app|
        user.is_lecturer?
      end

      can :edit, SemApp do |sem_app|
        sem_app.owned_by?(user)
      end
    end
  end
end
