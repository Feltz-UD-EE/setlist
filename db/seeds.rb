# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Instrument.create(name: "Drums")
Instrument.create(name: "Bass")
Instrument.create(name: "Guitar 1")
Instrument.create(name: "Guitar 2")
Instrument.create(name: "Keyboards 1")
Instrument.create(name: "Keyboards 2")
Instrument.create(name: "Vocals 1")
Instrument.create(name: "Vocals 2")
Instrument.create(name: "Harmonica")
Instrument.create(name: "Saxophone")
Instrument.create(name: "Trumpet")
Instrument.create(name: "Trombone")
Instrument.create(name: "Drums 2")
Instrument.create(name: "Engineer")

b = Band.create(name: "Silver Lake Band")

Player.create(first_name: "John", last_name: "Feltz", band_id: b.id)