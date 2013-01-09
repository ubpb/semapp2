# encoding: utf-8

# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.11' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem 'RedCloth',      :version => '4.2.3',   :lib => 'RedCloth'
  config.gem 'devise',        :version => '1.0.4',   :lib => 'devise'
  config.gem 'paperclip',     :version => '2.3.1.1', :lib => 'paperclip'
  config.gem 'will_paginate', :version => '2.3.12',  :lib => 'will_paginate'
  config.gem 'acts_as_list',  :version => '0.1.2',   :lib => 'acts_as_list'
  config.gem 'barby',         :version => '0.3.2',   :lib => 'barby'
  config.gem 'png',           :version => '1.1.0',   :lib => 'png'
  config.gem 'cancan',        :version => '1.0.2',   :lib => 'cancan'
  config.gem 'provideal-ui',  :version => '0.2.0',   :lib => 'pui'
  config.gem 'nokogiri',      :version => '1.4.2',   :lib => 'nokogiri'
  config.gem 'newrelic_rpm'

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  #config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  config.i18n.default_locale = :de

  # Use SQL schema format
  config.active_record.schema_format = :sql

  # Send mails using sendmail
  config.action_mailer.delivery_method = :sendmail

  # Definements (TODO: Implement this a better way)
  TRANSIT_SOURCE_SEMESTER_ID = 0 #
  TRANSIT_TARGET_SEMESTER_ID = 0 #

end
