class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.string :code, index: { unique: true }, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :nights, null: false
      t.integer :guests, null: false
      t.integer :adults, null: false
      t.integer :children, null: false
      t.integer :infants, null: false
      t.integer :status, null: false
      t.integer :currency, null: false
      t.string :payout_price, null: false
      t.string :security_price, null: false
      t.string :total_price, null: false

      t.references :guest, index: true, null: false

      t.timestamps
    end
  end
end
