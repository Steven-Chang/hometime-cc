# frozen_string_literal: true

class Guest < ApplicationRecord
  # === ASSOCIATIONS ===
  has_many :phone_numbers, as: :owner, dependent: :delete_all
  has_many :reservations, dependent: :restrict_with_exception

  # === VALIDATIONS ===
  validates :email, :first_name, :last_name, presence: true
  validates :email, uniqueness: { case_sensitive: false }

  # === NESTED ATTRIBUTES ===
  accepts_nested_attributes_for :phone_numbers
end
