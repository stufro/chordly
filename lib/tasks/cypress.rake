# frozen_string_literal: true

namespace :cypress do
  task :run do
    fail unless system('yarn cy:run')
  end
end