# frozen_string_literal: true

module Payload
  class ReservationProcessor < PayloadService
    def call
      parsed_payload = ReservationParser.call(@payload)
      reservation = Reservation.find_or_initialize_by(code: parsed_payload[:reservation][:code])
      if reservation.persisted?
        # Does not update guest details as guest already exists
        reservation.update!(parsed_payload[:reservation])
      else
        # Does not update guest details as guest already exists
        reservation.assign_attributes(parsed_payload[:reservation])
        guest = Guest.find_or_initialize_by(email: parsed_payload[:guest][:email])
        # Does not update guest details if guest already exists
        guest.assign_attributes(parsed_payload[:guest]) unless guest.persisted?
        reservation.update!(guest:)
      end
      reservation
    end
  end
end
