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

## Example use

#### Payload 1
```sh
curl --location --request POST 'localhost:3000/reservations/create_or_update' \
--header 'Content-Type: application/json' \
--data-raw '{
"reservation_code": "YYY12345678",
"start_date": "2021-04-14",
"end_date": "2021-04-18",
"nights": 4,
"guests": 4,
"adults": 2,
"children": 2,
"infants": 0,
"status": "accepted",
"guest": {
"first_name": "Wayne",
"last_name": "Woodbridge",
"phone": "639123456789",
"email": "wayne_woodbridge@bnb.com"
},
"currency": "AUD",
"payout_price": "4200.00",
"security_price": "500",
"total_price": "4700.00"
}'
```

#### Payload 2
```sh
curl --location --request POST 'localhost:3000/reservations/create_or_update' \
--header 'Content-Type: application/json' \
--data-raw '{
"reservation": {
"code": "XXX123456765",
"start_date": "2021-03-10",
"end_date": "2021-03-16",
"expected_payout_amount": "3800.00",
"guest_details": {
"localized_description": "4 guests",
"number_of_adults": 2,
"number_of_children": 2,
"number_of_infants": 0
},
"guest_email": "wayne_woodbridge2@bnb.com",
"guest_first_name": "Wayne",
"guest_last_name": "Woodbridge",
"guest_phone_numbers": [
"639123456789",
"639123456789"
],
"listing_security_price_accurate": "500.00",
"host_currency": "AUD",
"nights": 6,
"number_of_guests": 4,
"status_type": "accepted",
"total_paid_amount_accurate": "4300.00"
}
}'
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

The column for nights, guests and total_price may not be necessary. If necessary, they could be calculated in a before callback from the related fields. I decided to validate the fields instead as I'm not sure of the exact situation and thought we might be expected to validate the data.

#### PhoneNumber

Decided to create a PhoneNumber model as payload 2 had multiple phone numbers and it's likely that the system may need to store other entities phone numbers.

#### Single service for parsing: app/services/payload/reservation_parser.rb

Decided to have the parser for reservation payloads as a single service instead of a separate service for each payload as separate services were unlikely to be called. A single service also leads to DRY code as all parsed payloads need to have certain attributes formatted e.g. Reserveation enumerable fields.

#### Processing reservation payload: app/services/payload/reservation_processor.rb

This allows for creating or updating a Reservation based on the payload. Two things to note, as per the coding challenge instructions:
1. If a Guest already exists, it does not update the Guest's details.
2. If a Reservation already exists, it does not change the Guest.

#### Scaling and error handling

Depending on the circumstance, it may be beneficial to process the data in a background job. One reason for this is to reduce the number of servers required to run at any point, which would help with scaling. The other reason is for convenient error handling. If the background job raises an error, it would be much more convenient to fix the error and then run the background job again instead of having to go through the errors, retrieve the payloads and process them manually.
