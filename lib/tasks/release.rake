namespace :release do
  def release(type, special: false)
    system("semver inc #{type}")
    system("semver special '-pre'") if special
    Rake::Task["release:commit_and_tag"].invoke
  end

  task :commit_and_tag do
    new_tag = `semver tag`.strip
    if system("git add .semver && git commit -m 'chore: bump version to #{new_tag}' && git tag -a #{new_tag} -m 'chore: bump version to #{new_tag}'")
      puts "\nNew release #{new_tag} created\nPush new tag using: git push origin main --tags"
    else
      system("git checkout .semver")
      fail
    end
  end

  task :patch do |task, args|
    release("patch")
  end

  namespace :patch do
    task :pre do
      release("patch", special: true)
    end
  end

  task :minor do |task, args|
    release("minor")
  end

  namespace :minor do
    task :pre do
      release("minor", special: true)
    end
  end

  task :major do |task, args|
    release("major")
  end

  namespace :major do
    task :pre do
      release("major", special: true)
    end
  end
end