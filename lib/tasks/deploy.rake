namespace :release do
  task :patch do
    if system("semver inc patch && git tag -a $(semver tag) -m 'build: bump version to $(semver tag)'")
      puts "Push new tag using: git push origin main --tags"
    else
      fail
    end
  end

  task :minor do
    if system("semver inc minor && git tag -a $(semver tag) -m 'build: bump version to $(semver tag)'")
      puts "Push new tag using: git push origin main --tags"
    else
      fail
    end
  end

  task :major do
    if system("semver inc major && git tag -a $(semver tag) -m 'build: bump version to $(semver tag)'")
      puts "Push new tag using: git push origin main --tags"
    else
      fail
    end
  end
end