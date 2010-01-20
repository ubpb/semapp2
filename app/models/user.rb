# == Schema Information
# Schema version: 20091110135349
#
# Table name: users
#
#  id    :integer         not null, primary key
#  login :string(255)     not null
#  name  :string(255)     not null
#  email :string(255)
#

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
  # Devise (Aleph) callback
  #
  def on_successfull_authentication(aleph_user)
    if aleph_user.status.match(/^PA.+/)
      add_authority(Authority::LECTURER_ROLE)
    end
  end


  #
  # Checks for the ROLE_ADMIN authority
  #
  def is_admin?
    has_authority?(Authority::ADMIN_ROLE)
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

  def add_authority(name)
    unless has_authority?(name)
      authorities << Authority.find_by_name(name)
    end
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
