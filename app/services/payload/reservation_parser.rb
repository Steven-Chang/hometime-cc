# frozen_string_literal: true

module Payload
  class ReservationParser < PayloadService
    def call
      parsed_payload = if @payload['reservation_code']
        parse_payload_one
      elsif @payload['reservation']['code']
        parse_payload_two
      else
        raise StandardError, 'Invalid reservation payload.'
      end
      parsed_payload[:reservation][:status].downcase!
      parsed_payload[:reservation][:currency].downcase!
      parsed_payload[:guest][:phone_numbers_attributes].uniq!
      parsed_payload
    end

    private

      def parse_payload_one
        {
          reservation: {
            code: @payload['reservation_code'],
            start_date: @payload['start_date'],
            end_date: @payload['end_date'],
            nights: @payload['nights'],
            guests: @payload['guests'],
            adults: @payload['adults'],
            children: @payload['children'],
            infants: @payload['infants'],
            status: @payload['status'],
            currency: @payload['currency'],
            payout_price: @payload['payout_price'],
            security_price: @payload['security_price'],
            total_price: @payload['total_price']
          },
          guest: {
            email: @payload['guest']['email'],
            first_name: @payload['guest']['first_name'],
            last_name: @payload['guest']['last_name'],
            phone_numbers_attributes: [{ phone_number: @payload['guest']['phone'] }]
          }
        }
      end

      def parse_payload_two
        reservation_details = @payload['reservation']
        {
          reservation: {
            code: reservation_details['code'],
            start_date: reservation_details['start_date'],
            end_date: reservation_details['end_date'],
            nights: reservation_details['nights'],
            guests: reservation_details['number_of_guests'],
            adults: reservation_details['guest_details']['number_of_adults'],
            children: reservation_details['guest_details']['number_of_children'],
            infants: reservation_details['guest_details']['number_of_infants'],
            status: reservation_details['status_type'],
            currency: reservation_details['host_currency'],
            payout_price: reservation_details['expected_payout_amount'],
            security_price: reservation_details['listing_security_price_accurate'],
            total_price: reservation_details['total_paid_amount_accurate']
          },
          guest: {
            email: reservation_details['guest_email'],
            first_name: reservation_details['guest_first_name'],
            last_name: reservation_details['guest_last_name'],
            phone_numbers_attributes: reservation_details['guest_phone_numbers'].map { |phone_number| { phone_number: } }
          }
        }
      end
  end
end
