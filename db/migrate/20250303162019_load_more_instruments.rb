class LoadMoreInstruments < ActiveRecord::Migration[8.0]
  def up
    Instrument.create(name: "Harmonica")
    Instrument.create(name: "Saxophone")
    Instrument.create(name: "Trumpet")
    Instrument.create(name: "Trombone")
  end
end
