class User < ApplicationRecord

  # Relations
  has_many :ownerships, :dependent => :destroy
  has_many :sem_apps,   :through   => :ownerships

  # Validations
  validates :login, presence: true, uniqueness: { case_sensitive: false }
  validates :ilsuserid, presence: true, uniqueness: { case_sensitive: false }
  validates_presence_of :name


  def self.authenticate(attributes)
    login    = attributes[:login]
    password = attributes[:password]

    # Handle Admin PA -> PD switch
    if login =~ /PA10123456/i
      login = "PD10123456"
    end

    if (aleph_user = Aleph::Connector.new.authenticate(login, password)).is_a?(Aleph::User)
      create_or_update_aleph_user!(aleph_user)
    else
      raise "Aleph authentication failed"
    end
  end

  def self.exists_in_ils?(ils_account_no)
    Aleph::Connector.new.user_exists?(ils_account_no)
  end

  def login=(value)
    self[:login] = value.strip.upcase if value
  end

  def is_admin?
    is_admin
  end

  def is_lecturer?
    (login =~ /\APA|\APD|\APG/i).present?
  end

  #def to_s
  #  ["#{name} (#{login})", "#{email}"].map(&:presence).compact.join(', ').strip
  #end

  def self.create_or_update_aleph_user!(aleph_user)
    user = User.where(
      'ilsuserid=:ilsuserid OR login=:login', ilsuserid: aleph_user.id, login: aleph_user.login
    ).first_or_initialize

    user.attributes = {
      login: aleph_user.login,
      ilsuserid: aleph_user.id,
      name: aleph_user.name,
      email: aleph_user.email
    }

    user.save!

    user
  end

end
