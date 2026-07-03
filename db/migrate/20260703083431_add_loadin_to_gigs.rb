class AddLoadinToGigs < ActiveRecord::Migration[8.0]
  def change
    add_column :gigs, :loadin, :time
  end
end
