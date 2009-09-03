# == Schema Information
# Schema version: 20090831113245
#
# Table name: users
#
#  id                  :integer(4)      not null, primary key
#  authid              :string(255)     not null
#  active              :boolean(1)      not null
#  approved            :boolean(1)
#  firstname           :string(255)     not null
#  lastname            :string(255)     not null
#  login               :string(255)     not null
#  email               :string(255)     not null
#  phone               :string(255)
#  department          :string(255)
#  crypted_password    :string(255)     not null
#  password_salt       :string(255)     not null
#  persistence_token   :string(255)     not null
#  single_access_token :string(255)     not null
#  perishable_token    :string(255)     not null
#  login_count         :integer(4)      default(0), not null
#  failed_login_count  :integer(4)      default(0), not null
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#

class User < ActiveRecord::Base

  DEFAULT_AUTHID = 'internal'

  # Relations
  has_and_belongs_to_many :authorities
  has_many                :ownerships, :dependent => :destroy
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

  # Returns the current (logged in) user. Returns null
  # if there is no user logged in
  def self.current
    return @current_user if @current_user
    user_session = current_session
    @current_user = user_session.user if user_session and user_session.user
  end

  # Returns the current user session
  def self.current_session
    UserSession.find
  end

  def logout
    if User.current_session
      User.current_session.destroy
    end
    @current_user = nil
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

  #
  # To string
  #
  def to_s
    return "#{self.login}@#{self.authid}"
  end

  def phone
    t = read_attribute(:phone)
    t unless t.blank?
  end

  def department
    t = read_attribute(:department)
    t unless t.blank?
  end

end
