# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Guest do
  describe 'VALIDATIONS' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }

    context 'when a guest exists' do
      before { create(:guest) }

      it { should validate_uniqueness_of(:email).case_insensitive }
    end
  end
end
