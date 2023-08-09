require 'rails_helper'

RSpec.describe Payload::ReservationParser do
  describe '#call' do
    let(:payload_one_json) { JSON.parse(File.read("spec/fixtures/payloads/reservations/payload_one.json")) }
    let(:payload_two_json) { JSON.parse(File.read("spec/fixtures/payloads/reservations/payload_two.json")) }

    describe '#call' do
      context 'when payload corresponds to payload one' do
        it 'returns a properly parsed json' do
          parsed_json = described_class.call(payload_one_json)
          expected_json = {
            reservation: {
              code: payload_one_json['reservation_code'],
              start_date: payload_one_json['start_date'],
              end_date: payload_one_json['end_date'],
              nights: payload_one_json['nights'],
              guests: payload_one_json['guests'],
              adults: payload_one_json['adults'],
              children: payload_one_json['children'],
              infants: payload_one_json['infants'],
              status: payload_one_json['status'],
              currency: payload_one_json['currency'],
              payout_price: payload_one_json['payout_price'],
              security_price: payload_one_json['security_price'],
              total_price: payload_one_json['total_price']
            },
            guest: {
              email: payload_one_json['guest']['email'],
              first_name: payload_one_json['guest']['first_name'],
              last_name: payload_one_json['guest']['last_name'],
              phone_numbers_attributes: [{ phone_number: payload_one_json['guest']['phone'] }]
            }
          }
          expect(parsed_json).to eq expected_json
        end
      end

      context 'when payload corresponds to payload two' do
        it 'returns a properly parsed json' do
          parsed_json = described_class.call(payload_two_json)
          reservation_details = payload_two_json['reservation']
          expected_json = {
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
              phone_numbers_attributes: reservation_details['guest_phone_numbers'].uniq.map { |phone_number| { phone_number: } }
            }
          }
          expect(parsed_json).to eq expected_json
        end
      end

      context 'when payload can not be parsed' do
        let(:payload_incorrect_json) do
          payload_two_json['reservation']['code'] = nil
          payload_two_json
        end

        it 'raises an error' do
          expect { described_class.call(payload_incorrect_json) }.to raise_error(StandardError, 'Invalid reservation payload.')
        end
      end
    end
  end
end
