module SemApp2
  def self.config
    @@config ||= OpenStruct.new
  end

  def self.config=(hash)
    @@config = OpenStruct.new(hash)
  end
end

SemApp2.config = YAML.load_file("config/sem_app.yml")[Rails.env]


require 'aleph_connector'
Aleph::Connector.base_url             = SemApp2.config.aleph_base_url
Aleph::Connector.library              = SemApp2.config.aleph_library
Aleph::Connector.search_base          = SemApp2.config.aleph_search_base
Aleph::Connector.allowed_user_types   = SemApp2.config.aleph_allowed_user_types
Aleph::Connector.disallowed_ban_codes = SemApp2.config.aleph_disallowed_ban_codes
