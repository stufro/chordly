
namespace :cy do
  task :run do
    RakeAnnouncer.log_step "Running Cypress"
    fail unless system('yarn cy:run')
  end

  task :open do
    RakeAnnouncer.log_step "Running test Rails server and opening Cypress"
    system("foreman start -f Procfile.test")
  end
end