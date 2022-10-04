
namespace :cypress do
  task :run do
    RakeAnnouncer.log_step "Running Cypress ('yarn cy:run')"
    fail unless system('yarn cy:run')
  end
end