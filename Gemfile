source 'https://rubygems.org'

gem 'rails',                '~> 4.0.1'
gem 'rails-i18n',           '~> 4.0.0'
gem 'deep_cloning',         '~> 2.0.0'
gem 'pg',                   '~> 0.17.0'
gem 'cancan',               '~> 1.0.2'
gem 'barby',                '~> 0.4.4'
gem 'rqrcode',              '~> 0.4.2'
gem 'chunky_png',           '~> 1.2.0'
gem 'paperclip',            '~> 3.5.2'
gem 'will_paginate',        '~> 3.0.5'
gem 'acts_as_list',         '~> 0.1.2'
gem 'RedCloth',             '~> 4.2.3'
gem 'prarupa',              '~> 0.1.2' # provides old textilize helper methods
gem 'dynamic_form',         '~> 1.1.4' # provides the old f.error_messages method
gem 'formtastic',           github: 'ubpb/formtastic', branch: '1.2-stable'
gem 'nokogiri',             '~> 1.6.0'
gem 'protected_attributes', '~> 1.0.5' # Needed as long as we migrated to strong parameters

# asset related gems
gem 'coffee-rails',         '~> 4.0.0'
gem 'sass-rails',           '~> 4.0.1'
gem 'slim',                 '~> 2.0.2'
gem 'therubyracer',         '~> 0.12.0', platforms: :ruby
gem 'therubyrhino',         '~> 2.0.2',  platforms: :jruby
gem 'uglifier',             '>= 2.3.2'

# assets
gem 'jquery-rails',         '~> 2.1.4' # we can only use jquery till 1.8, because jquery-tools relies on $.browser
# gem 'jquery-ui-rails',      '~> 4.1.0'

# development
group :development, :test do
  gem 'pry',                     '0.9.12.2' # 0.9.12.3 has a coloring bug in its repl which shows annoying ansi colors codes
  gem 'pry-nav',                 '~> 0.2.3'
  gem 'pry-syntax-hacks',        '~> 0.0.6' # some shortcuts for the pry console
end
