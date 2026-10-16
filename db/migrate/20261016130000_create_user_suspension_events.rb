class CreateUserSuspensionEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :user_suspension_events do |t|
      # Keep these IDs even if the user or admin is later deleted.
      t.bigint :player_id, null: false
      t.bigint :admin_id, null: false
      t.string :action, null: false
      t.datetime :created_at, null: false
    end

    add_index :user_suspension_events, :player_id
    add_index :user_suspension_events, :admin_id
    add_index :user_suspension_events, :created_at
  end
end
