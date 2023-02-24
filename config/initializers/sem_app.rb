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

  def self.catalog_base_url
    self.config.catalog_base_url || "https://katalog.ub.uni-paderborn.de"
  end
end

SemApp2.config = YAML.load_file("config/sem_app.yml")[Rails.env]
