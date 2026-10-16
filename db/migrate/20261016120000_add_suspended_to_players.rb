class AddSuspendedToPlayers < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :suspended, :boolean, default: false, null: false
  end
end
