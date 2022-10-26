# Contributing to Chordly
Dependencies:
- Ruby 3.1.2
- Rails 7.0.4
- PostgreSQL
- Yarn
- Chrome or Chromium browser (for [Grover gem](https://github.com/Studiosity/grover))

## Writing some code

If you want to fix a bug or add a new feature, please:

1. [Fork the project](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/about-forks).
2. Create a feature branch (`git checkout -b my-new-feature`).
3. Make your changes. Include tests for your changes, otherwise I may accidentally break them in the future.
4. Run the tests with the `rake` command. Make sure that they are still passing.
5. Write [descriptive commit messages](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html) and follow [Angular's commit format](https://gist.github.com/brianclements/841ea7bffdb01346392c#type) e.g. `feat: add new feature`.
6. Push the branch to GitHub (`git push origin my-new-feature`).
7. [Create a Pull Request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request) and submit it to be merged with the main branch.

## Setting up development server
1. Install Ruby dependencies
```bash
bundle install
```

2. Install JavaScript dependencies
```bash
yarn install
```

3. Initialize database and seed with dummy data
```bash
./bin/rails db:create db:migrate db:seed
```

4. Run local server
```bash
./bin/dev
```

5. Open application in your browser: http://localhost:3000

## Running tests
```bash
rake
```

## Seeding database with example chord sheets and users
```bash
./bin/rails db:seed
```
