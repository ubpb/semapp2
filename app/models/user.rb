# encoding: utf-8

class User < ActiveRecord::Base

  # Relations
  has_and_belongs_to_many :authorities
  has_many                :ownerships, :dependent => :destroy
  has_many                :sem_apps, :through => :ownerships

  # Validations
  validates_presence_of :login
  validates_presence_of :name

  # Protected attributes. FIXME: Replace with strong parameters
  attr_accessible :login, :name, :email


  class << self
    def authenticate(attributes)
      aleph = Aleph::Connector.new
      aleph_user = aleph.authenticate(attributes[:login], attributes[:password])
      raise "Aleph authentication failed" unless aleph_user and aleph_user.is_a? Aleph::User
      user = create_or_update_aleph_user!(aleph_user)
      user.add_authority(Authority::LECTURER_ROLE) if aleph_user.status.match(/\APA.+/)
      user
    end

    private
      def create_or_update_aleph_user!(aleph_user)
        user = self.find_by_login(aleph_user.user_id)
        user.present? ? update_user!(user, aleph_user) : create_user!(aleph_user)
      end

      def create_user!(aleph_user)
        User.create!(:login => aleph_user.user_id, :name => aleph_user.name, :email => aleph_user.email)
      end

      def update_user!(user, aleph_user)
        user.update_attributes!(:name => aleph_user.name, :email => aleph_user.email)
        user
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
      return true if sem_app.creator == self

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
  def to_s()
    s  = "#{self.name} (#{self.login})"
    s << ", #{self.email}" if self.email.present?
    return s
  end

end
