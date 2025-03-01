# join table with attributes
class CreateListSongs < ActiveRecord::Migration[8.0]
  def change
    create_table :list_songs do |t|
      t.references :list
      t.references :song
      t.integer :position
      t.timestamps
    end
  end
end
