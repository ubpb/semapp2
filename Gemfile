source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby IO.read(".ruby-version").strip

gem "acts_as_list",          "~> 1.1"
gem "acts_as_singleton",     "~> 0.0.8"
gem "addressable",           "~> 2.8"
gem "alma_api",              "~> 2.0"
gem "auto_strip_attributes", "~> 2.6"
gem "barby",                 "~> 0.6.5"
gem "cancancan",             "~> 3.5"
gem "chunky_png",            "~> 1.3.8"
gem "coffee-rails",          "~> 5.0.0"
gem "deep_cloneable",        "~> 3.2.0"
gem "dynamic_form",          "~> 1.3"  # provides the old f.error_messages method
gem "formtastic",            "~> 5.0"
gem "jbuilder",              "~> 2.12"
gem "jquery-rails",          "~> 4.3"
gem "jquery-ui-rails",       "~> 6.0.1"
gem "mysql2",                ">= 0.4.4"
gem "nokogiri",              "~> 1.12"
gem "paperclip",             "~> 6.1"
gem "puma",                  ">= 3.11"
gem "rack-attack",           "~> 6.6"
gem "rails",                 "~> 7.1.0"
gem "rails-i18n",            "~> 7.0"
gem "RedCloth",              "~> 4.3.2"
gem "rubyzip",               "~> 1.3.0", require: "zip"
gem "sassc-rails",           "~> 2.1"
gem "slim",                  "~> 5.2"
gem "uglifier",              ">= 3.2.0"
gem "will_paginate",         "~> 4.0"

gem "bootsnap", ">= 1.4.2", require: false
gem "highline", ">= 2.0" # Used by rake custom task

group :production do
  gem "newrelic_rpm", ">= 4.5.0"
end

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem "capistrano-bundler", "~> 2.0"
  gem "capistrano-passenger", "~> 0.2"
  gem "capistrano-rails", "~> 1.6"
  gem "capistrano-rvm", "~> 0.1"
  gem "capistrano", "~> 3.11"
  gem "i18n-debug", ">= 1.2"
  gem "i18n-tasks", ">= 1.0"
  gem "letter_opener_web", ">= 2.0"
  gem "ubpb-rubocop-config", github: "ubpb/rubocop-config", branch: "main", require: "ubpb/rubocop-config"
  gem "web-console", ">= 3.3"
  gem "listen"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver", ">= 3.1"
  gem "webdrivers", ">= 4.3"
end
