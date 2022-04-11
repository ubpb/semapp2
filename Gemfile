source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby IO.read(".ruby-version").strip

gem "acts_as_list",          "~> 0.9.9"
gem "acts_as_singleton",     "~> 0.0.8"
gem "auto_strip_attributes", "~> 2.2.0"
gem "barby",                 "~> 0.6.5"
gem "cancancan",             "~> 2.0.0"
gem "chunky_png",            "~> 1.3.8"
gem "coffee-rails",          "~> 5.0.0"
gem "deep_cloneable",        "~> 3.0.0"
gem "dynamic_form",          "~> 1.1.4"  # provides the old f.error_messages method
gem "formtastic",            "~> 3.1.5"
gem "highline",              "~> 1.7.8" # Used by rake custom task
gem "jbuilder",              "~> 2.7.0"
gem "jquery-rails",          "~> 4.3.1"
gem "jquery-ui-rails",       "~> 6.0.1"
gem "mysql2",                ">= 0.4.4"
gem "nokogiri",              "~> 1.13"
gem "paperclip",             "~> 5.2.1"
gem "puma",                  ">= 3.11"
gem "rack-attack",           "~> 5.0.1"
gem "rails",                 "~> 6.0.0"
gem "rails-i18n",            "~> 6.0.0"
gem "RedCloth",              "~> 4.3.2"
gem "rubyzip",               "~> 1.3.0", require: "zip"
gem "sass-rails",            "~> 5"
gem "slim",                  "~> 3.0"
gem "uglifier",              ">= 3.2.0"
gem "will_paginate",         "~> 3.1.6"

gem "bootsnap", ">= 1.4.2", require: false

group :production do
  gem "newrelic_rpm", ">= 4.5.0"
end

group :development, :test do
  gem "letter_opener", ">= 1.7.0"
  gem "pry-byebug",    ">= 3.6", platform: :mri
  gem "pry-rails",     ">= 0.3", platform: :mri
end

group :development do
  gem "capistrano",           "~> 3.11"
  gem "capistrano-bundler",   "~> 1.6.0"
  gem "capistrano-passenger", "~> 0.2.0"
  gem "capistrano-rails",     "~> 1.4.0"
  gem "capistrano-rvm",       "~> 0.1.2"
  gem "web-console",          ">= 3.3.0"
  gem "listen",               ">= 3.0.5", "< 3.2"
end
