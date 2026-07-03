class CreateGigLists < ActiveRecord::Migration[8.0]
  def change
    create_table :gig_lists do |t|
      t.references :gig, null: false, foreign_key: true
      t.references :list, null: false, foreign_key: true
      t.integer :position, null: false

      t.timestamps
    end

    add_index :gig_lists, [ :gig_id, :list_id ], unique: true
    add_index :gig_lists, [ :gig_id, :position ]
  end
end
