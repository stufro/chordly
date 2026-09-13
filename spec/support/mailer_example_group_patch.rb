# frozen_string_literal: true

# PROBLEM:
# In Rails 8.2+ (and Rails main branch), `ActionDispatch::Routing::UrlFor` initializes
# `default_url_options` with a frozen empty hash (`{}.freeze`).
#
# In rspec-rails (<= 8.0.4), `RSpec::Rails::MailerExampleGroup` attempts to mutate this
# hash directly in place when setting up mailer spec example groups:
#
#   options = ::Rails.configuration.action_mailer.default_url_options || {}
#   options.each { |key, value| default_url_options[key] = value }
#
# This raises `FrozenError: can't modify frozen Hash: {}`.
#
# EXPECTED FIX IN RSPEC-RAILS:
# In `lib/rspec/rails/example/mailer_example_group.rb`, replace the in-place hash mutation with:
#
#   self.default_url_options = (default_url_options || {}).merge(options)
#
# This patch redefines the `included` hook on `MailerExampleGroup` to safely assign
# `self.default_url_options` without mutating the existing frozen hash.

if defined?(ActionMailer) && defined?(RSpec::Rails::MailerExampleGroup)
  module RSpec
    module Rails
      module MailerExampleGroup
        @_included_block = proc do
          include ::Rails.application.routes.url_helpers

          options = ::Rails.configuration.action_mailer.default_url_options || {}
          self.default_url_options = (default_url_options || {}).merge(options)
        end
      end
    end
  end
end
