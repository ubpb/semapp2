class User < ActiveRecord::Base

  # Relations
  has_many :ownerships, :dependent => :destroy
  has_many :sem_apps,   :through   => :ownerships

  # Validations
  validates_presence_of :login
  validates_presence_of :name

  class << self
    def authenticate(attributes)
      aleph_user = Aleph::Connector.new.authenticate(attributes[:login], attributes[:password])
      raise "Aleph authentication failed" unless aleph_user && aleph_user.is_a?(Aleph::User)
      create_or_update_aleph_user!(aleph_user)
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

  def is_admin?
    is_admin
  end
  
  end

  def to_s
    s  = "#{self.name} (#{self.login})"
    s << ", #{self.email}" if self.email.present?
    return s
  end

end
