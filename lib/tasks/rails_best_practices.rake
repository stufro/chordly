
task :rails_best_practices do
  RakeAnnouncer.log_step "Running rails_best_practices"
  fail unless system('bundle exec rails_best_practices')
end