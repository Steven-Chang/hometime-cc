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
        ActiveRecord::Base.transaction do
          guest = Guest.find_or_initialize_by(email: parsed_payload[:guest][:email])
          guest.update!(parsed_payload[:guest]) unless guest.persisted?
          reservation.assign_attributes(parsed_payload[:reservation])
          reservation.update!(guest:)
        end
      end
      reservation
    end
  end
end
