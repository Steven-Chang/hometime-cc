# frozen_string_literal: true

module Payload
  class ReservationProcessor < PayloadService
    def call
      parsed_payload = ReservationParser.call(@payload)
      reservation = Reservation.find_or_initialize_by(code: parsed_payload[:code])
      if reservation.persisted?
        reservation.update!(parsed_payload[:reservation])
      else
        reservation.assign_attributes(parsed_payload[:reservation])
        guest = Guest.find_or_initialize_by(email: parsed_payload[:guest][:email])
        guest.assign_attributes(parsed_payload[:guest])
        reservation.update!(guest:)
      end
      reservation
    end
  end
end
