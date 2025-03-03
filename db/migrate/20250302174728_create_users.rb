class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :email, :string, null: false
    add_column :players, :encrypted_password, :string, limit: 128, null: false
    add_column :players, :confirmation_token, :string, limit: 128
    add_column :players, :remember_token, :string, limit:128, null: false

    add_index :players, :email
    add_index :players, :confirmation_token, unique: true
    add_index :players, :remember_token, unique: true
  end
end
