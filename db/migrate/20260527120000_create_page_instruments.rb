class CreatePageInstruments < ActiveRecord::Migration[8.0]
  class MigrationPage < ActiveRecord::Base
    self.table_name = "pages"
  end

  class MigrationPageInstrument < ActiveRecord::Base
    self.table_name = "page_instruments"
  end

  def change
    create_table :page_instruments do |t|
      t.references :page, null: false, foreign_key: true
      t.references :instrument, null: false, foreign_key: true

      t.timestamps
    end

    add_index :page_instruments, [:page_id, :instrument_id], unique: true

    reversible do |dir|
      dir.up do
        MigrationPage.reset_column_information
        MigrationPage.where.not(instrument_id: nil).find_each do |page|
          MigrationPageInstrument.find_or_create_by!(page_id: page.id, instrument_id: page.instrument_id)
        end
      end
    end
  end
end
