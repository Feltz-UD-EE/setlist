class CreateSongs < ActiveRecord::Migration[8.0]
  def change
    create_table :songs do |t|
      t.string :title
      t.string :version
      t.string :performer
      t.integer :duration
      t.integer :tempo
      t.string :intro
      t.references :band
      t.timestamps
    end
  end
end
