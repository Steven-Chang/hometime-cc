# frozen_string_literal: true

FactoryBot.define do
  factory :reservation do
    sequence(:code) { |n| n }
    start_date { Date.current - 1.day }
    end_date { Date.current + 1.day }
    nights { 2 }
    guests { 6 }
    adults { 2 }
    children { 2 }
    infants { 2 }
    status { 0 }
    currency { 0 }
    payout_price { '4200' }
    security_price { '500' }
    total_price { '4700' }
    guest
  end
end
