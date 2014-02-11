class User < ActiveRecord::Base

  # Relations
  has_many :ownerships, :dependent => :destroy
  has_many :sem_apps,   :through   => :ownerships

  # Validations
  validates_presence_of :login
  validates_presence_of :name

  def self.authenticate(attributes)
    if (aleph_user = Aleph::Connector.new.authenticate(attributes[:login], attributes[:password])).is_a?(Aleph::User)
      create_or_update_aleph_user!(aleph_user)
    else
      raise "Aleph authentication failed"
    end
  end

  def is_admin?
    is_admin
  end

  def is_lecturer?
    (login =~ /\Apa/i).present?
  end

  def to_s
    ["#{name} (#{login})", "#{email}"].map(&:presence).compact.join(', ').strip
  end

 private

  def self.create_or_update_aleph_user!(aleph_user)
    if (user = User.find_by(login: aleph_user.user_id)).present?
      user.update_attributes!(:name => aleph_user.name, :email => aleph_user.email)
      user
    else
      User.create!(:login => aleph_user.user_id, :name => aleph_user.name, :email => aleph_user.email)
    end
  end

end
