class CreateListSongs < ActiveRecord::Migration[8.0]
  def change
    create_table :list_songs do |t|
      t.timestamps
    end
  end
end
