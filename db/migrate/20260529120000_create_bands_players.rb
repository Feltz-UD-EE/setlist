class CreateBandsPlayers < ActiveRecord::Migration[8.0]
  def up
    create_join_table :bands, :players do |t|
      t.index [:band_id, :player_id], unique: true
      t.index [:player_id, :band_id]
    end

    execute <<~SQL.squish
      INSERT INTO bands_players (band_id, player_id)
      SELECT band_id, id
      FROM players
      WHERE band_id IS NOT NULL
      ON CONFLICT DO NOTHING
    SQL
  end

  def down
    drop_join_table :bands, :players
  end
end
