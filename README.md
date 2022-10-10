# Chordly

A free, open-source, online chord sheet creator.

## Development
Dependencies:
- Ruby 3.1.2
- Rails 7.0.4
- PostgreSQL
- Yarn

### Installation
1. Install Ruby dependencies
```bash
bundle install
```

2. Install JavaScript dependencies
```bash
yarn install
```

3. Initialize database
```bash
rails db:create db:migrate db:seed
```

### Running tests
```bash
rake cy:open # this will open Cypress and also run a test server which tests will be run against in the following command
rake
```