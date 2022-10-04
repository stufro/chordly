begin
  require "bundler/audit/cli"

  desc "Updates the ruby-advisory-db and runs audit"
  task "bundler:audit" do
    RakeAnnouncer.log_step "Running bundler_audit: Checking gems for known security warnings"
    Bundler::Audit::CLI.start ["update"]
  end
rescue LoadError
  task "bundler:audit" do
    abort "bundler_audit rake task is not available in production"
  end
end