# frozen_string_literal: true

class Reservation < ApplicationRecord
  # === ENUMERABLES ===
  enum currency: { aud: 0 }
  enum status: { accepted: 0 }

  # === ASSOCIATIONS ===
  belongs_to :guest

  # === VALIDATIONS ===
  validates :code, :start_date, :end_date, :nights, :guests, :adults, :children, :infants, :status, :currency, :payout_price, :security_price, :total_price, presence: true
  validates :code, uniqueness: { case_sensitive: false }
  validates :guests, :nights, numericality: { greater_than_or_equal_to: 1, only_integer: true }
  validates :adults, :children, :infants, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validate :guests_equate_to_sum_of_guest_types
  validate :nights_correspond_to_dates
  validate :total_price_equates_to_sum_of_payout_price_and_security_price

  private

    def guests_equate_to_sum_of_guest_types
      return unless guests && adults && children && infants
      return if guests == (adults + children + infants)

      errors.add(:guests, 'must equal the sum of guest types.')
    end

    def nights_correspond_to_dates
      return unless nights && end_date && start_date
      return if nights == (end_date - start_date)

      errors.add(:nights, 'must correspond to dates.')
    end

    def total_price_equates_to_sum_of_payout_price_and_security_price
      return unless total_price && payout_price && security_price
      return if total_price.to_d == (payout_price.to_d + security_price.to_d)

      errors.add(:total_price, 'must equal the sum of payout_price and security_price.')
    end
end
