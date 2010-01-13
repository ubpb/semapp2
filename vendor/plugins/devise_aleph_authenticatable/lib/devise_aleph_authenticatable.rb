# encoding: utf-8

#
# Require Devise
#
begin
  require 'devise'
rescue
  gem 'devise'
  require 'devise'
end

#
# Require out stuff
#
require 'devise_aleph_authenticatable/model'
require 'devise_aleph_authenticatable/strategy'
require 'devise_aleph_authenticatable/routes'

#
# Load :aleph_authenticatable into Devise
#
Devise::ALL.unshift :aleph_authenticatable
Devise::STRATEGIES.unshift :aleph_authenticatable
Devise::CONTROLLERS[:sessions].unshift :aleph_authenticatable

#
# Autoload our model
#
Devise::Models.module_eval do
  autoload :AlephAuthenticatable, 'devise_aleph_authenticatable/model'
end