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

    if (
      AlmaConnector.authenticate(login, password) &&
      (alma_user = AlmaConnector.resolve_user(login))
    )
      if alma_user.email.blank?
        raise "Anmeldung fehlgeschlagen. In Ihrem Konto ist keine E-Mail Adresse konfiguriert."
      end

      unless ["01", "02", "10", "13"].include?(alma_user.user_group)
        raise "Anmeldung nicht möglich."
      end

      # TODO: Check for Blocks

      create_or_update_alma_user!(alma_user)
    else
      raise 'Anmeldung fehlgeschlagen. Überprüfen Sie Login und Passwort.'
    end
  end

  def self.exists_in_ils?(ils_account_no)
    AlmaConnector.user_exists?(ils_account_no)
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

  def self.create_or_update_alma_user!(alma_user)
    user = User.where(
      'ilsuserid=:ilsuserid OR login=:login', ilsuserid: alma_user.primary_id, login: alma_user.login
    ).first_or_initialize

    user.attributes = {
      login: alma_user.login,
      ilsuserid: alma_user.primary_id,
      name: alma_user.name,
      email: alma_user.email
    }

    user.save!

    user
  end

end
