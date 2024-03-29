# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Guest do
  describe 'ASSOCIATIONS' do
    it { should have_many(:phone_numbers).dependent(:delete_all) }
    it { should have_many(:reservations).dependent(:restrict_with_exception) }
  end

  describe 'VALIDATIONS' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }

    context 'when a guest exists' do
      before { create(:guest) }

      it { should validate_uniqueness_of(:email).case_insensitive }
    end
  end

  describe 'NESTED ATTRIBUTES' do
    it { should accept_nested_attributes_for(:phone_numbers) }
  end
end
