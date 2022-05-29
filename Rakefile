# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"
require "rubocop/rake_task"
require "bundler/audit/task"
require "slim_lint/rake_task"

Bundler::Audit::Task.new
RuboCop::RakeTask.new
SlimLint::RakeTask.new

task default: %i[bundler:audit rails_best_practices rubocop slim_lint spec cypress:run brakeman:run]

Rails.application.load_tasks
