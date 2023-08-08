# frozen_string_literal: true

FactoryBot.define do
  factory :guest do
    sequence(:email) { |n| "email#{n}@email.com" }
    first_name { 'Steven' }
    last_name { 'Chang' }
  end
end
