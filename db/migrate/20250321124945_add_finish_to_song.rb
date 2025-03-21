class AddFinishToSong < ActiveRecord::Migration[8.0]
  def change
    add_column :songs, :finish, :string
  end
end
