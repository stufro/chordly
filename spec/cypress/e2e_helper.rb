# This is loaded once before the first command is executed

begin
  require "database_cleaner-active_record"
rescue LoadError
  begin
    require "database_cleaner"
  rescue LoadError # rubocop:disable Lint/SuppressedException
  end
end

begin
  require "factory_bot_rails"
rescue LoadError
  begin
    require "factory_girl_rails"
  rescue LoadError # rubocop:disable Lint/SuppressedException
  end
end

require "cypress_on_rails/smart_factory_wrapper"

factory = CypressOnRails::SimpleRailsFactory
factory = FactoryBot if defined?(FactoryBot)
factory = FactoryGirl if defined?(FactoryGirl)

CypressOnRails::SmartFactoryWrapper.configure(
  always_reload: !Rails.configuration.cache_classes,
  factory:,
  files: [
    Rails.root.join("spec/factories.rb"),
    Rails.root.join("spec/factories/**/*.rb")
  ]
)
