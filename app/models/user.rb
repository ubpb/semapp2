class User < ActiveRecord::Base

  has_and_belongs_to_many :authorities

  acts_as_authentic do |c|
    # for available options see documentation in: Authlogic::ActsAsAuthentic
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
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
  end

end
