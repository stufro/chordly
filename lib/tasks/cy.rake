namespace :cy do
  task :run do
    RakeAnnouncer.log_step "Running Cypress"
    if File.exist?(Rails.root.join("tmp/pids/test_server.pid"))
      raise unless system("yarn cy:run")
    else
      RakeAnnouncer.log_step "Starting test server & running tests"
      fork { exec("RAILS_ENV=test bin/rails server -p 5017 -P tmp/pids/test_server.pid") }
      passed = system("yarn cy:run")

      pid = File.read(Rails.root.join("tmp/pids/test_server.pid"))
      RakeAnnouncer.log_step "Stopping test server"
      system("kill #{pid}")
      raise unless passed
    end
  end

  task :open do
    RakeAnnouncer.log_step "Running test Rails server and opening Cypress"
    system("foreman start -f Procfile.test")
  end
end
