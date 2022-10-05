
namespace :brakeman do
  desc "Run Brakeman"
  task :run, :output_files do |t, args|
    RakeAnnouncer.log_step "Running brakeman"
    require "brakeman"

    files = args[:output_files].split(' ') if args[:output_files]
    Brakeman.run :app_path => ".", :output_files => files, :print_report => true
  end

  desc "Check your code with Brakeman"
  task :check do
    require "brakeman"
    RakeAnnouncer.log_step "Running Brakeman"
    result = Brakeman.run app_path: ".", print_report: true, pager: false, output_format: :plain
    exit Brakeman::Warnings_Found_Exit_Code unless result.filtered_warnings.empty?
  end
end
