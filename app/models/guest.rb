# frozen_string_literal: true

class Guest < ApplicationRecord
  # === ASSOCIATIONS ===
  has_many :phone_numbers, as: :owner, dependent: :delete_all

  # === VALIDATIONS ===
  validates :email, :first_name, :last_name, presence: true
  validates :email, uniqueness: { case_sensitive: false }
end
