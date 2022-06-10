module SemApp2
  def self.config
    @@config ||= OpenStruct.new
  end

  def self.config=(hash)
    @@config = OpenStruct.new(hash)
  end

  def self.alma_api
    @@alma_api ||= ExlApi.configure do |config|
      config.api_key      = self.config.alma_api_key
      config.api_base_url = self.config.alma_api_base_url || "https://api-eu.hosted.exlibrisgroup.com/almaws/v1"
      config.language     = self.config.alma_api_language || "de"
    end
  end
end

SemApp2.config = YAML.load_file("config/sem_app.yml")[Rails.env]


require 'aleph_connector'
Aleph::Connector.base_url             = SemApp2.config.aleph_base_url
Aleph::Connector.library              = SemApp2.config.aleph_library
Aleph::Connector.search_base          = SemApp2.config.aleph_search_base
Aleph::Connector.allowed_user_types   = SemApp2.config.aleph_allowed_user_types
Aleph::Connector.disallowed_ban_codes = SemApp2.config.aleph_disallowed_ban_codes
