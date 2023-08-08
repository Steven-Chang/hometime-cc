class CreatePhoneNumbers < ActiveRecord::Migration[7.0]
  def change
    create_table :phone_numbers do |t|
      t.string :phone_number, null: false
      t.references :owner, polymorphic: true, index: false, null: false

      t.timestamps
    end
    add_index :phone_numbers, %i[owner_type owner_id phone_number], unique: true,  name: 'phone_numbers_by_owner_phone_number'
  end
end
