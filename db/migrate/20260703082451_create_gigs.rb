class CreateGigs < ActiveRecord::Migration[8.0]
  def change
    create_table :gigs do |t|
      t.date :date, null: false
      t.references :band, null: false, foreign_key: true
      t.string :client, null: false
      t.string :contact, null: false
      t.string :phone
      t.string :address
      t.references :booked_by, null: false, foreign_key: { to_table: :players }
      t.decimal :fee, precision: 10, scale: 2
      t.string :venue
      t.time :soundcheck
      t.time :start
      t.time :end
      t.text :notes
      t.text :retrospective

      t.timestamps
    end

    add_index :gigs, [ :band_id, :date ]
  end
end
