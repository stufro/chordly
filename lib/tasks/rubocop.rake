begin
  require "rubocop/rake_task"

  RuboCop::RakeTask.new do |task|
    task.options = ["--parallel"]
  end

  task :rubocop_announce do
    RakeAnnouncer.log_step "Running Rubocop"
  end

  task rubocop: :rubocop_announce
rescue LoadError
  desc "Rubocop is not available in production"
  task :rubocop do
    abort "Rubocop is not avaialble in production"
  end
end