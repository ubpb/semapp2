class User < ActiveRecord::Base

  # Relations
  has_and_belongs_to_many :authorities
  has_many                :ownerships, :dependent => :destroy
  has_many                :sem_apps, :through => :ownerships

  devise :aleph_authenticatable

  # Validations
  validates_presence_of :login
  validates_presence_of :name

  #
  # Checks for the ROLE_ADMIN authority
  #
  def is_admin?
    has_authority?('ROLE_ADMIN')
  end

  #
  # Checks if the user has a certain authority
  #
  def has_authority?(name)
    authorities.each do |a|
      return true if a.name == name
    end
    return false
  end

  #
  # checks if the user own the sem app
  #
  def owns_sem_app?(sem_app)
    if sem_app.present?
      ownerships.each do |o|
        if o.sem_app.present?
          return true if sem_app.id == o.sem_app.id
        end
      end
    end
    return false
  end

  #
  # To string
  #
  def to_s
    return "#{self.login} - #{self.name}"
  end

end
