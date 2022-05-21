# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.0"

gem "bootsnap", require: false
gem "cssbundling-rails"
gem "image_processing", "~> 1.2"
gem "jbuilder"
gem "jsbundling-rails"
gem "musique"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "rails", "~> 7.0.3"
gem "slim"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem "brakeman"
  gem "bundler-audit"
  gem "rack-mini-profiler"
  gem "rails_best_practices"
  gem "rubocop-rails", require: false
  gem "slim_lint"
  gem "web-console"
end
