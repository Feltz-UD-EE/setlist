require "fileutils"

class RenamePagesToSheets < ActiveRecord::Migration[8.0]
  def up
    rename_table :pages, :sheets
    rename_table :page_instruments, :sheet_instruments
    rename_column :sheet_instruments, :page_id, :sheet_id
    move_uploads("page", "sheet")
  end

  def down
    move_uploads("sheet", "page")
    rename_column :sheet_instruments, :sheet_id, :page_id
    rename_table :sheet_instruments, :page_instruments
    rename_table :sheets, :pages
  end

  private

  def move_uploads(from, to)
    from_path = Rails.root.join("public", "uploads", from)
    to_path = Rails.root.join("public", "uploads", to)
    return unless File.directory?(from_path)
    return if File.exist?(to_path)

    FileUtils.mv(from_path, to_path)
  end
end
