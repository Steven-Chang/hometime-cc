# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/reservations' do
  let(:valid_headers) do
    {}
  end
  let(:payload_two_json) { JSON.parse(File.read('spec/fixtures/payloads/reservations/payload_two.json')) }

  describe 'POST /creat_or_update' do
    context 'with valid parameters' do
      it 'creates or updates a reservation' do
        expect do
          post create_or_update_reservations_url,
               params: payload_two_json, headers: valid_headers, as: :json
        end.to change(Reservation, :count).by(1)
      end

      it 'renders a JSON response with the corresponding reservation, guest and phone numbers' do
        post create_or_update_reservations_url,
             params: payload_two_json, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
        code = Payload::ReservationParser.call(payload_two_json)[:reservation][:code]
        expect(response.body).to eq(Reservation.find_by(code:).to_json(include: { guest: { include: { phone_numbers: {} } } }))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Reservation' do
        expect do
          post create_or_update_reservations_url,
               params: {}, as: :json
        end.not_to change(Reservation, :count)
      end

      it 'renders a JSON response with errors for the new reservation' do
        post create_or_update_reservations_url,
             params: {}, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end
end
