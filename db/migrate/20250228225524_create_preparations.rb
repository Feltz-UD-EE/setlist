class CreatePreparations < ActiveRecord::Migration[8.0]
  def change
    create_table :preparations do |t|
      t.string :instruction
      t.references :song
      t.references :instrument
      t.timestamps
    end
  end
end
