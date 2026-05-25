class CreateBandInvitations < ActiveRecord::Migration[8.0]
  def change
    create_table :band_invitations do |t|
      t.references :band, null: false, foreign_key: true
      t.string :token_digest
      t.datetime :expires_at
      t.datetime :used_at

      t.timestamps
    end
    add_index :band_invitations, :token_digest, unique: true
  end
end
