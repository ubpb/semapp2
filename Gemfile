source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "acts_as_list",          "~> 0.9.9"
gem "acts_as_singleton",     "~> 0.0.8"
gem "auto_strip_attributes", "~> 2.2.0"
gem "barby",                 "~> 0.6.5"
gem "cancancan",             "~> 2.0.0"
gem "chunky_png",            "~> 1.3.8"
gem "coffee-rails",          "~> 4.2.2"
gem "deep_cloneable",        "~> 2.3.1"
gem "dynamic_form",          "~> 1.1.4"  # provides the old f.error_messages method
gem "formtastic",            "~> 3.1.5"
gem "highline",              "~> 1.7.8" # Used by rake custom task
gem "jbuilder",              "~> 2.7.0"
gem "jquery-rails",          "~> 4.3.1"
gem "jquery-ui-rails",       "~> 6.0.1"
gem "mysql2",                ">= 0.4.4", "< 0.6.0"
gem "nokogiri",              "~> 1.8.1"
gem "paperclip",             "~> 5.2.1"
gem "pg",                    ">= 0.21.0", "< 1.0.0"
gem "rack-attack",           "~> 5.0.1"
gem "rails",                 "~> 5.1.4"
gem "rails-i18n",            "~> 5.0.4"
gem "RedCloth",              "~> 4.3.2"
gem "rubyzip",               "~> 1.2.1", require: "zip"
gem "sass-rails",            "~> 5.0.6"
gem "slim",                  "~> 3.0.8"
gem "uglifier",              ">= 3.2.0"
gem "will_paginate",         "~> 3.1.6"

gem "sequel",                "~> 5.18", require: false

group :production do
  gem "therubyracer", ">= 0.12.3"
  gem "newrelic_rpm", ">= 4.5.0"
end

group :development, :test do
  gem "pry-byebug",         ">= 3.5.0"
  gem "pry-rails",          "~> 0.3.6"
  gem "puma",               "~> 3.10"
end

group :development do
  gem "capistrano",         "~> 3.9.1"
  gem "capistrano-bundler", "~> 1.3.0"
  gem "capistrano-rails",   "~> 1.3.0"
  gem "capistrano-rvm",     "~> 0.1.2"
  gem "letter_opener",      "~> 1.4.1"
  gem "listen",             ">= 3.0.5", "< 3.2"
  gem "web-console",        ">= 3.3.0"
end
