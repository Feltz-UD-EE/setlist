# file attachments
#
class CreatePages < ActiveRecord::Migration[8.0]
  def change
    create_table :pages do |t|
      t.integer :sort_order, null: false
      t.references :song, null: false
      t.references :instrument, null: true
      t.string :img       # uses Carrierwave
      t.timestamps
    end
  end
end
