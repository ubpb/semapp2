class Ability
  include CanCan::Ability

  def initialize(user)
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
        sem_app.owned_by?(user) && !sem_app.archived
      end

      can :manage, SemApp do |sem_app|
        sem_app.creator == user
      end

      can :transit, SemApp do |sem_app|
        ApplicationSettings.instance.transit_target_semester.present? &&
          (sem_app.semester.id == ApplicationSettings.instance.transit_source_semester.id)
      end
    end
  end
end
