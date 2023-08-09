# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payload::ReservationProcessor do
  describe '#call' do
    let(:payload_one_json) { JSON.parse(File.read('spec/fixtures/payloads/reservations/payload_one.json')) }
    let(:parsed_payload_one_json) { Payload::ReservationParser.call(payload_one_json) }
    let(:reservation) { described_class.call(payload_one_json) }

    describe '#call' do
      context 'when reservation with code does not exist' do
        context 'when guest with email does not exist' do
          it 'creates the guest number details with details in json' do
            expect { reservation }.to change(Guest, :count).by(1)
            expect(reservation.guest.email).to eq parsed_payload_one_json[:guest][:email]
            expect(reservation.guest.first_name).to eq parsed_payload_one_json[:guest][:first_name]
            expect(reservation.guest.last_name).to eq parsed_payload_one_json[:guest][:last_name]
          end

          it 'creates the phone number details with details in json' do
            expect { reservation }.to change(PhoneNumber, :count).by(parsed_payload_one_json[:guest][:phone_numbers_attributes].length)
            parsed_payload_one_json[:guest][:phone_numbers_attributes].each do |phone_number_object|
              expect(reservation.guest.phone_numbers.find_by(phone_number: phone_number_object[:phone_number]).present?).to be true
            end
          end
        end

        context 'when guest with email exists' do
          before do
            guest = Guest.create(email: parsed_payload_one_json[:guest][:email], first_name: 'a', last_name: 'b')
            guest.phone_numbers.create(phone_number: '000')
          end

          it 'does not update the guest details' do
            expect(reservation.guest.first_name).not_to eq(parsed_payload_one_json[:guest][:first_name])
            expect(reservation.guest.last_name).not_to eq(parsed_payload_one_json[:guest][:last_name])
            expect(reservation.guest.phone_numbers.first.phone_number).not_to eq(parsed_payload_one_json[:guest][:phone_numbers_attributes].first[:phone_number])
          end
        end

        it 'creates a new reservation with corresponding details' do
          parsed_reservation_json = parsed_payload_one_json[:reservation]
          expect(reservation.code).to eq(parsed_reservation_json[:code])
          expect(reservation.start_date).to eq(Date.parse(parsed_reservation_json[:start_date]))
          expect(reservation.end_date).to eq(Date.parse(parsed_reservation_json[:end_date]))
          expect(reservation.nights).to eq(parsed_reservation_json[:nights])
          expect(reservation.guests).to eq(parsed_reservation_json[:guests])
          expect(reservation.adults).to eq(parsed_reservation_json[:adults])
          expect(reservation.children).to eq(parsed_reservation_json[:children])
          expect(reservation.infants).to eq(parsed_reservation_json[:infants])
          expect(reservation.status).to eq(parsed_reservation_json[:status])
          expect(reservation.currency).to eq(parsed_reservation_json[:currency])
          expect(reservation.payout_price).to eq(parsed_reservation_json[:payout_price])
          expect(reservation.security_price).to eq(parsed_reservation_json[:security_price])
          expect(reservation.total_price).to eq(parsed_reservation_json[:total_price])
          expect(reservation.guest).to eq(Guest.find_by(email: parsed_payload_one_json[:guest][:email]))
        end
      end

      context 'when reservation with code exists' do
        before { reservation }

        context 'when guest details in payload is different to what is in system' do
          before do
            reservation.guest.update(email: 'a@b.com', first_name: 'a', last_name: 'b')
          end

          it 'does not update the guest details' do
            expect(reservation.guest.email).not_to eq(parsed_payload_one_json[:guest][:email])
            expect(reservation.guest.first_name).not_to eq(parsed_payload_one_json[:guest][:first_name])
            expect(reservation.guest.last_name).not_to eq(parsed_payload_one_json[:guest][:last_name])
          end
        end

        context 'when guest phone details in payload is different to what is in system' do
          before do
            reservation.guest.phone_numbers.first.update(phone_number: '000')
          end

          it 'does not update the guest details' do
            expect(reservation.guest.phone_numbers.first.phone_number).not_to eq(parsed_payload_one_json[:guest][:phone_numbers_attributes].first[:phone_number])
          end
        end

        context 'when reservation detains in payload is different to what is in system' do
          before do
            reservation.update(start_date: Date.current - 10.days, end_date: Date.current + 5.days, nights: 15, guests: 100, adults: 33, children: 33, infants: 34, status: 'rejected', currency: 'usd', payout_price: '10', security_price: '10', total_price: '20')
          end

          it 'does updates the reservation details' do
            reservation = described_class.call(payload_one_json)
            parsed_reservation_json = parsed_payload_one_json[:reservation]
            expect(reservation.code).to eq(parsed_reservation_json[:code])
            expect(reservation.start_date).to eq(Date.parse(parsed_reservation_json[:start_date]))
            expect(reservation.end_date).to eq(Date.parse(parsed_reservation_json[:end_date]))
            expect(reservation.nights).to eq(parsed_reservation_json[:nights])
            expect(reservation.guests).to eq(parsed_reservation_json[:guests])
            expect(reservation.adults).to eq(parsed_reservation_json[:adults])
            expect(reservation.children).to eq(parsed_reservation_json[:children])
            expect(reservation.infants).to eq(parsed_reservation_json[:infants])
            expect(reservation.status).to eq(parsed_reservation_json[:status])
            expect(reservation.currency).to eq(parsed_reservation_json[:currency])
            expect(reservation.payout_price).to eq(parsed_reservation_json[:payout_price])
            expect(reservation.security_price).to eq(parsed_reservation_json[:security_price])
            expect(reservation.total_price).to eq(parsed_reservation_json[:total_price])
          end
        end
      end
    end
  end
end
