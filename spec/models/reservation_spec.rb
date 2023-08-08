# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reservation do
  let(:reservation) { build(:reservation) }

  describe 'ENUMS' do
    it { should define_enum_for(:currency).with_values(aud: 0) }
    it { should define_enum_for(:status).with_values(accepted: 0) }
  end

  describe 'ASSOCIATIONS' do
    it { should belong_to(:guest) }
  end

  describe 'VALIDATIONS' do
    it { should validate_numericality_of(:nights).only_integer.is_greater_than_or_equal_to(1) }
    it { should validate_numericality_of(:guests).only_integer.is_greater_than_or_equal_to(1) }
    it { should validate_numericality_of(:adults).only_integer.is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:children).only_integer.is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:infants).only_integer.is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
    it { should validate_presence_of(:nights) }
    it { should validate_presence_of(:guests) }
    it { should validate_presence_of(:adults) }
    it { should validate_presence_of(:children) }
    it { should validate_presence_of(:infants) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:currency) }
    it { should validate_presence_of(:payout_price) }
    it { should validate_presence_of(:security_price) }
    it { should validate_presence_of(:total_price) }

    context 'when a reservation exists' do
      before { create(:reservation) }

      it { should validate_uniqueness_of(:code).case_insensitive }
    end

    describe '#guests_equate_to_sum_of_guest_types' do
      context 'when guests does not equate to sum of guest types' do
        before { reservation.guests = 100 }

        it 'is not valid' do
          expect(reservation.valid?).to be false
          expect(reservation.errors.first.type).to eq 'must equal the sum of guest types.'
        end
      end

      context 'when guests equates to sum of guest types' do
        it 'is valid' do
          expect(reservation.valid?).to be true
        end
      end
    end

    describe '#nights_correspond_to_dates' do
      context 'when nights does not correspond to dates' do
        before { reservation.nights = 100 }

        it 'is not valid' do
          expect(reservation.valid?).to be false
          expect(reservation.errors.first.type).to eq 'must correspond to dates.'
        end
      end

      context 'when nights corresponds to dates' do
        it 'is valid' do
          expect(reservation.valid?).to be true
        end
      end
    end

    describe '#total_price_equates_to_sum_of_payout_price_and_security_price' do
      context 'when total_price does not equate to sum of payout_price and security_price' do
        before { reservation.total_price = '0' }

        it 'is not valid' do
          expect(reservation.valid?).to be false
          expect(reservation.errors.first.type).to eq 'must equal the sum of payout_price and security_price.'
        end
      end

      context 'when total_price equates to sum of payout_price and security_price' do
        it 'is valid' do
          expect(reservation.valid?).to be true
        end
      end
    end
  end
end
