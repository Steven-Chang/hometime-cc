# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhoneNumber do
  describe 'ASSOCIATIONS' do
    it { should belong_to(:owner) }
  end

  describe 'VALIDATIONS' do
    it { should validate_presence_of(:phone_number) }

    context 'when a phone number exists' do
      before { create(:phone_number) }

      it { should validate_uniqueness_of(:phone_number).scoped_to(%i[owner_type owner_id]).case_insensitive }
    end
  end
end
