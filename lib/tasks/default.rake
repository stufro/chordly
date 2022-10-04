require "rake_announcer"

Rake::Task[:default].prerequisites.clear if Rake::Task.task_defined? :default

task default: %i[bundler:audit brakeman:check rails_best_practices rubocop slim_lint rspec cypress:run]