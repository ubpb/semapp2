source 'https://rubygems.org'

gem 'rails', '3.0.17'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'rails-i18n' # TODO: currently will_paginate-translations are added

gem 'pg'

# the Devise 1.0.x line isn't Rails 3 compatible
# gem 'devise', '~> 1.0.4', require: 'devise'
gem 'devise',        '~> 1.1.7',    require: 'devise'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'



gem 'cancan',        '1.0.2',    require: 'cancan'

gem 'barby',         '0.3.2',    require: 'barby'

# gem 'RubyInline' # although png has this as a dependency, the gemspec of png 1.2.0 doesn't specify this anymore
# gem 'png',           '~> 1.2.0',    require: 'png'
# TODO: use this fork: https://github.com/bensomers/png
# 			to solve this issue: https://github.com/seattlerb/png/pull/1
# gem 'png', require: 'png', :github => "bensomers/png"
gem 'png',           '~> 1.1.0',    require: 'png'

gem 'paperclip',     '2.3.1.1',  require: 'paperclip'
gem 'will_paginate', '3.0.3'
# gem 'will_paginate', '2.3.12',   require: 'will_paginate'
gem 'acts_as_list',  '0.1.2',    require: 'acts_as_list'

gem 'RedCloth', '~> 4.2.3', require: 'RedCloth'
gem 'prarupa' # provides old textilize helper methods
# gem 'formatize' # the official gem for providing old textilize helper methods, but this also depends on BlueCloth

gem 'dynamic_form' # provides the old f.error_messages method

gem 'provideal-ui',  '0.2.0',   require: 'pui', path: "vendor/gems/provideal-ui-0.2.0"
gem 'provideal-plugin-utils',  '0.1.3', path: "vendor/gems/provideal-plugin-utils-0.1.3"
gem 'formtastic', '1.2.3'


# AlephConnector dependencies
gem 'nokogiri', '1.5.5',   require: 'nokogiri'



# TODO: Can/shall we put this into this group?
=begin
group :production do
  gem 'newrelic_rpm'
end
=end

# TODO: This should be used, instead of the self-made stuff
# gem 'jquery-rails'

=begin
# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end
=end


=begin
# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'rspec-rails' #, '2.11.0'
  # gem 'guard-rspec' #, '1.2.1'
  # gem 'guard-spork' #, '1.2.0'
  # gem 'spork' #, '0.9.2'
  # gem 'faker' #, '1.0.1'
  # gem 'launchy' # for debugging
end

group :test do
	gem 'factory_girl_rails' #, '4.1.0'
  gem 'capybara' #, '1.1.2'
end
=end

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'


