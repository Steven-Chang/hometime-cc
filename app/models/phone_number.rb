# frozen_string_literal: true

class PhoneNumber < ApplicationRecord
  # === ASSOCIATIONS ===
  belongs_to :owner, polymorphic: true

  # === VALIDATIONS ===
  validates :phone_number, presence: true
  validates :phone_number, uniqueness: { case_sensitive: false, scope: %i[owner_type owner_id] }
end
