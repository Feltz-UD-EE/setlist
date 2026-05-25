class AddAccountFieldsToPlayers < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :admin, :boolean, null: false, default: false
    add_column :players, :invitation_accepted_at, :datetime

    reversible do |dir|
      dir.up do
        execute <<~SQL.squish
          UPDATE players
          SET email = 'johncfeltz@gmail.com', admin = TRUE
          WHERE first_name = 'John' AND last_name = 'Feltz'
        SQL
      end
    end
  end
end
