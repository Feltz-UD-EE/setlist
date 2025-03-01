class CreateLists < ActiveRecord::Migration[8.0]
  def change
    create_table :lists do |t|
      t.string :name
      t.string :notes
      t.references :band
      t.timestamps
    end
  end
end
