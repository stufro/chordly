begin
  require "rspec/core/rake_task"

  RSpec::Core::RakeTask.new(:rspec)

  task :rspec_announce do
    RakeAnnouncer.log_step "Running specs"
  end

  task rspec: :rspec_announce
rescue LoadError
  desc "RSpec is not available in production"
  task :rspec do
    abort "RSpec is not available in production"
  end
end
