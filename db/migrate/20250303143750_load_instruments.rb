class LoadInstruments < ActiveRecord::Migration[8.0]
  def up
    Instrument.create(name: "Drums")
    Instrument.create(name: "Drums 2")
    Instrument.create(name: "Bass")
    Instrument.create(name: "Guitar 1")
    Instrument.create(name: "Guitar 2")
    Instrument.create(name: "Keyboards 1")
    Instrument.create(name: "Keyboards 2")
    Instrument.create(name: "Vocals 1")
    Instrument.create(name: "Vocals 2")
    Instrument.create(name: "Engineer")
  end
end
