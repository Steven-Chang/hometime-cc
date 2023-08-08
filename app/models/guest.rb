# frozen_string_literal: true

class Guest < ApplicationRecord
  # === VALIDATIONS ===
  validates :email, :first_name, :last_name, presence: true
  validates :email, uniqueness: { case_sensitive: false }
end
