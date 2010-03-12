# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.cache_store                                   = :file_store, File.join(RAILS_ROOT, 'tmp', 'cache')

# See everything in the log (default is :info)
config.log_level = :warn

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Enable threaded mode
# config.threadsafe!

# Hack to make ruby_inline work with passenger
# on production systems
# @see http://www.viget.com/extend/rubyinline-in-shared-rails-environments/
temp = Tempfile.new('ruby_inline', '/tmp')
dir = temp.path
temp.delete
Dir.mkdir(dir, 0755)
ENV['INLINEDIR'] = dir

