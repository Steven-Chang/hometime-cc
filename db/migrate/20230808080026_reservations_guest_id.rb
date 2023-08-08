class ReservationsGuestId < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key "reservations", "guests", name: "reservations_guest_id_fk"
  end
end
