class CreateInstrumentPlayers < ActiveRecord::Migration[8.0]
  def change
    create_join_table :instruments, :players
  end
end
