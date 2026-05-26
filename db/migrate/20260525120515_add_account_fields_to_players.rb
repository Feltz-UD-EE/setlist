class AddAccountFieldsToPlayers < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :admin, :boolean, null: false, default: false
    add_column :players, :invitation_accepted_at, :datetime

    reversible do |dir|
      dir.up do
        Player.reset_column_information
        Player.where(first_name: "John", last_name: "Feltz").update_all(email: "johncfeltz@gmail.com", admin: true)
      end
    end
  end
end
