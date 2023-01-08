source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "bootsnap", require: false
gem "cssbundling-rails"
gem "devise"
gem "flipper"
gem "flipper-active_record"
gem "flipper-ui"
gem "grover"
gem "image_processing", "~> 1.2"
gem "jbuilder"
gem "jsbundling-rails"
gem "local_time"
gem "meta-tags"
gem "music", github: "stufro/music", branch: "special_enharmonics"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "rails"
gem "redcarpet", "~> 3.5"
gem "rubyzip"
gem "sassc-rails"
gem "semver"
gem "slim"
gem "sprockets-rails"
gem "stimulus-rails"
gem "term-ansicolor"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "uglifier"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

group :development, :test do
  gem "cypress-on-rails", "~> 1.0"
  gem "database_cleaner"
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails"
  gem "rails-controller-testing"
  gem "rspec-rails"
end

group :development do
  gem "brakeman"
  gem "bundler-audit"
  gem "foreman"
  gem "rack-mini-profiler"
  gem "rails_best_practices"
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "slim_lint"
  gem "solargraph"
  gem "web-console"
end
