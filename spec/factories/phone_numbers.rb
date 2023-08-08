# frozen_string_literal: true

FactoryBot.define do
  factory :phone_number do
    sequence(:phone_number) { |n| n }
    owner factory: :guest
  end
end
