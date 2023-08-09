# Hometime Coding Challenge

## About

1. Start a Ruby on Rails project that is purely an API app. ✅
2. Create one API endpoint that can accept both payload formats. See payloads at the end of this document. ✅
3. Your code should not require any additional headers or parameters to distinguish between the 2 payloads. ✅
4. Parse and save the payloads to a Reservation model that belongs to a Guest model. Reservation code and guest email field should be unique. ✅
5. API should be able accept changes to the reservation. e.g., change in status, check-in/out dates, number of guests, etc... ✅
6. Add a README file to the root of your repository with clear instructions on how to set up and run your app. ✅
7. Your submission should be available in a public git repository of your choice. Alternatively, you can submit a zipped folder of your source code. ✅

## Prerequisites

- Ruby 3.2.1
- Rails 7.0.6
- Postgres

## Getting started

```
bundle
rake db:setup
rails s
```

## Testing

```
rake db:test:prepare
rubocop -A
rspec
rake immigrant:check_keys
rake active_record_doctor
```

## Thoughts

#### Reservation

The column for nights and guests may not be necessary. If necessary, they could be calculated in a before callback from the related fields. I decided to validate the fields instead as I'm not sure of the exact situation and thought we might be expected to validate the data.

#### PhoneNumber

Decided to create a PhoneNumber model as payload 2 had multiple phone numbers and it's likely that the system may need to store other enteties phone numbers.

#### Single service for parsing: app/services/payload/reservation_parser.rb

Decided to have the parser for reservation payloads as a single service instead of a separate service for each payload as separate services were unlikely to be called. A single service also leads to DRY code as all parsed payloads need to have certain attributes formatted e.g. Reserveation enumerable fields.

#### Processing reservation payload: app/services/payload/reservation_processor.rb

This allows for creating or updating a Reservation based on the payload. Two things to note, as per the coding challenge instructions:
1. If a Guest already exists, it does not update the Guest's details.
2. If a Reservation already exists, it does not change the Guest.

#### Scaling and error handling

Depending on the circumstance, it may be beneficial to process the data in a background job. One reason for this is to reduce the number of servers required to run at any point, which would help with scaling. The other reason is for convenient error handling. If the background job raises an error, it would be much more convenient to fix the error and then run the background job again instead of having to go through the errors, retrieve the payloads and process them manually.
