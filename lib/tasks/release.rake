namespace :release do
  task :commit_and_tag do
    new_tag = `semver tag`.strip
    if system("git add .semver && git commit -m 'chore: bump version to #{new_tag}' && git tag -a #{new_tag} -m 'chore: bump version to #{new_tag}'")
      puts "\nNew release #{new_tag} created\nPush new tag using: git push origin main --tags"
    else
      system("git checkout .semver")
      fail
    end
  end

  task :patch do
    system("semver inc patch")
    Rake::Task["release:commit_and_tag"].invoke
  end

  task :minor do
    system("semver inc patch")
    Rake::Task["release:commit_and_tag"].invoke
  end

  task :major do
    system("semver inc patch")
    Rake::Task["release:commit_and_tag"].invoke
  end
end