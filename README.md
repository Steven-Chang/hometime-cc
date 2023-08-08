# Hometime cc

## Prerequisites

- Ruby 3.2.1
- Rails 7.0.6
- Postgres

## Getting started

```
bundle
rake db:setup
rake db:test:prepare
rails s
```

## Testing

```
rubocop -A
rspec
rake immigrant:check_keys
rake active_record_doctor
```
