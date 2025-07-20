#!/bin/bash

set -e

if [[ "$1" != "major" && "$1" != "minor" && "$1" != "patch" ]]; then
  echo "Usage: $0 [major|minor|patch]"
  exit 1
fi

semver inc "$1"
git add .
git commit -m "chore: bump version"
git tag "$(semver)"

echo
echo "Now run git push origin main --tags"
