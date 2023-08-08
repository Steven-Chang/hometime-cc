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

## Reasons for decisions

#### app/services/payload/reservation_parser.rb

Single service for pasing: Decided to have the payload parser for reservation payloads as a single service instead of a separate service for each payload. This is because the results of the parse needs to be formatted for Reservation enumerables and a central point would DRY up the code.

#### Scaling and error handling

Depending on the circumstance, I would probably have the info processed in a background job so that if there were issues, we could fix the issue that stops the job from saving or delete the job as required without having to retrieve the failed updates. This would also allow the system to handle large bursts of info without having to worry about the system crashing.
