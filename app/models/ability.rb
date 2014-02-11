class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present? and user.is_admin?
      can :manage, :all
    else
      #
      # Sem Apps
      #
      can :read, SemApp do |sem_app|
        sem_app.approved? || (user.present? && sem_app.owned_by?(user))
      end

      can :create, SemApp do |sem_app|
        user.present? && user.is_lecturer?
      end

      can :edit, SemApp do |sem_app|
        user.present? && sem_app.owned_by?(user) && !sem_app.archived
      end

      can :transit, SemApp do |sem_app|
        sem_app.semester.id == ApplicationSettings.instance.transit_source_semester.id
      end
    end
  end
end
