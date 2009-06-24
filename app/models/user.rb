class User < ActiveRecord::Base

  DEFAULT_AUTHID = 'internal'

  # Relations
  has_and_belongs_to_many :authorities
  has_many                :ownerships
  has_many                :sem_apps, :through => :ownerships

  # Validations
  validates_presence_of :authid
  validates_presence_of :firstname
  validates_presence_of :lastname
  # ... more validation is done by AuthLogic

  # Setup Authlogic
  acts_as_authentic do |c|
    # for available options see documentation in: Authlogic::ActsAsAuthentic
    c.crypto_provider   = Authlogic::CryptoProviders::BCrypt
    c.validations_scope = :authid
  end

  # Callback: Before save
  def before_validation
    self.authid = DEFAULT_AUTHID unless authid
  end

  #
  # Accessor for email field. Always convert to downcase
  #
  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  #
  # Set the password (and the password_confirmation)
  #
  def set_password(password)
    self.password = password
    self.password_confirmation = password
  end

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
  # Checks if the user is managed in an external
  # system.
  #
  def externally_managed?
    self.authid != DEFAULT_AUTHID
  end

  #
  # Returns the full name in one call
  #
  def full_name
    return "#{firstname} #{lastname}"
  end

  #
  # AuthLogic state callback
  #
  def active?
    return self.active
  end

  #
  # AuthLogic state callback
  #
  def approved?
    return self.approved
  end

end
