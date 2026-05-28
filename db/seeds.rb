# This file should ensure the existence of records required to run the
# application in every environment. It is safe to run more than once.

admin_email = "johncfeltz@gmail.com"

instrument_names = [
  "Drums",
  "Drums 2",
  "Bass",
  "Guitar",
  "Guitar 2",
  "Keyboards",
  "Keyboards 2",
  "Vocals",
  "Vocals 2",
  "Harmonica",
  "Saxophone",
  "Trumpet",
  "Trombone",
  "Engineer"
]

instruments = instrument_names.index_with do |name|
  Instrument.find_or_create_by!(name: name)
end

band = Band.find_or_create_by!(name: "Silver Lake Band")
Band.where.not(id: band.id).find_each(&:destroy!)

song_rows = [
  ["867-5309 Jenny", "Tommy Twotone", 200, "", ""],
  ["Baba O'Reilly", "The Who", 200, "organ", "F"],
  ["Bad Moon Rising", "Credence Clearwater Revival", 180, "", ""],
  ["Better Man", "Pearl Jam", 200, "Keyboard and plucked guitar", "D"],
  ["Big Empty", "Stone Temple Pilots", 180, "Keyboard then guitar", "E"],
  ["Boulevard of Broken Dreams", "Green Day", 240, "", ""],
  ["Breakfast in America", "Supertramp", 200, "Bass and keyboard 4 measures", "A"],
  ["Californication", "Red Hot Chili Peppers", 240, "Bass and Casio", "A minor"],
  ["Changes in Latitude", "Jimmy Buffet", 180, "", ""],
  ["Come Monday", "Jimmy Buffet", 240, "", ""],
  ["Come to my Window", "Melissa Ethridge", 200, "drum count all start", "G"],
  ["Daydream Believer", "The Monkees", 180, "", ""],
  ["Dead Flowers", "The Rolling Stones", 180, "Drum count, all start", "a capella"],
  ["December", "Collective Soul", 200, "organ", "C"],
  ["Don't Look Back in Anger", "Dobie Gray", 220, "", ""],
  ["Don't Stop", "Fleetwood Mac", 200, "drum count all start", "A"],
  ["Down by the Water", "The Decembrists", 180, "Drums 2 measures", "E minor"],
  ["Down Under", "Men at Work", 220, "", ""],
  ["Drift Away", "Dobie Gray", 220, "", ""],
  ["Drops of Jupiter", "Train", 200, "organ", "F"],
  ["Dust in the Wind", "Kansas", 180, "", ""],
  ["Eyes on the Prize", "Bruce Springsteen", 200, "Keyboard", "A minor"],
  ["Faithfully", "Journey", 200, "", ""],
  ["Folsom Prison Blues", "Johnny Cash", 200, "drum count all start", "F"],
  ["Gimme Some Lovin", "Spencer Davis Group", 220, "Drum count, keyboard and bass", "G"],
  ["Have You Ever Seen the Rain", "Credence Clearwater Revival", 160, "Drum count, all start", "C"],
  ["Hold my Hand", "Hootie and the Blowfish", 200, "Drum count, all start", "A"],
  ["I'm Eighteen", "Alice Cooper", 180, "Drum count, keyboard and harmonica", "Extended harmonica C/D/E minor"],
  ["It's a Good Life if You Don't Weaken", "The Tragically Hip", 200, "drum count all start", "Em"],
  ["It's So Easy", "Linda Ronstadt", 200, "drum count all start", "full a capella"],
  ["Keep on Rocking in the Free World", "Neil Young", 240, "Drum count, all start", "E"],
  ["Like a Hurricane", "Neal Young", 180, "Slow keyboard then harmonica", "A"],
  ["Little Black Submarines", "The Black Keys", 200, "drum count all start", "A"],
  ["Lonely Boy", "The Black Keys", 200, "Drum count, all start", "A"],
  ["Long Train Runnin'", "The Doobie Brothers", 200, "drum count all start", "Em"],
  ["Manic Monday", "The Bangles", 180, "Drum count, all start", "D"],
  ["Melt With You", "Modern English", 220, "Drum count, all start", "C"],
  ["Monday Morning", "Fleetwood Mac", 200, "drum count all start", "C"],
  ["No Time", "The Guess Who", 200, "drum count all start", "D"],
  ["Rain on the Scarecrow", "John Mellencamp", 240, "Keyboard", "E minor"],
  ["Rebel Yell", "Billy Idol", 180, "Keyboard and plucked guitar", "G (??)"],
  ["Running on Empty", "Jackson Brown", 220, "Keyboard and bass", "A"],
  ["Southern Cross", "Crosby Stills & Nash", 220, "Drum count, all start", "D"],
  ["Standing Still", "Jewel", 200, "drum count all start", "C"],
  ["Summer of 69", "Bryan Adams", 200, "guitar and vocal", "D"],
  ["Sunspot Baby", "Bob Seger", 180, "Drum count, all start", "E"],
  ["Sympathy for the Devil", "The Rolling Stones", 240, "Keyboard and Vocals", "E"],
  ["Take it Easy", "The Eagles", 240, "Drum count, all start", "E minor"],
  ["Take Me Home Country Roads", "John Denver", 200, "drum count then organ", "full a capella"],
  ["The Funeral", "Yungblud", 200, "drum count all start", "D"],
  ["The Old Man Down the Road", "John Fogerty", 180, "Drum count, all start", "Very slow vocal + C/D/E"],
  ["Twilight Zone", "Golden Earring", 300, "Keyboard and guitar, then spoken word vocals", "A minor"],
  ["Vacation", "The Go-Gos", 200, "Drum count, all start", "E"],
  ["Wagon Wheel", "Old Crow Medicine Show", 180, "Slow keyboard", "a capella"],
  ["You May be Right", "Billy Joel", 220, "Drum count, all start", "A"],
  ["Zombie", "Yungblud", 200, "guitar 2 measures then full band", "C"]
]

songs = song_rows.each_with_object({}) do |(title, performer, duration, intro, finish), catalog|
  song = band.songs.find_or_initialize_by(title: title)
  song.update!(
    performer: performer,
    duration: duration,
    intro: intro,
    finish: finish
  )
  catalog[title] = song
end

band.songs.where.not(title: songs.keys).find_each(&:destroy!)

preparation_rows = [
  ["Breakfast in America", "Bass", "Capo 3"],
  ["Breakfast in America", "Guitar", "Capo 3"],
  ["Breakfast in America", "Harmonica", "C harmonica"],
  ["Breakfast in America", "Keyboards", "Tune up 3"],
  ["Down by the Water", "Harmonica", "G harmonica"],
  ["Eyes on the Prize", "Bass", "Capo 3"],
  ["Eyes on the Prize", "Guitar", "Capo 3"],
  ["Eyes on the Prize", "Harmonica", "C harmonica"],
  ["Eyes on the Prize", "Keyboards", "Tune up 3"],
  ["Folsom Prison Blues", "Harmonica", "?? harmonica in rack"],
  ["Gimme Some Lovin", "Keyboards", "Casio mode X"],
  ["Hold my Hand", "Bass", "Capo 2"],
  ["Hold my Hand", "Guitar", "Capo 2"],
  ["Hold my Hand", "Keyboards", "Tune up 2"],
  ["I'm Eighteen", "Harmonica", "C harmonica"],
  ["It's a Good Life if You Don't Weaken", "Bass", "capo 4"],
  ["It's a Good Life if You Don't Weaken", "Guitar", "capo 4"],
  ["It's a Good Life if You Don't Weaken", "Keyboards", "tune +4"],
  ["Lonely Boy", "Harmonica", "G harmonica"],
  ["Long Train Runnin'", "Bass", "capo 3"],
  ["Long Train Runnin'", "Guitar", "capo 3"],
  ["Long Train Runnin'", "Keyboards", "tune +3"],
  ["Manic Monday", "Keyboards", "Casio mode X"],
  ["Rain on the Scarecrow", "Bass", "Capo 2"],
  ["Rain on the Scarecrow", "Guitar", "Capo 2"],
  ["Rain on the Scarecrow", "Keyboards", "Tune up 2"],
  ["Rebel Yell", "Bass", "Capo 1"],
  ["Rebel Yell", "Guitar", "Capo 1"],
  ["Rebel Yell", "Keyboards", "Tune up 1"],
  ["Running on Empty", "Keyboards", "Casio mode X"],
  ["Standing Still", "Bass", "capo 2"],
  ["Standing Still", "Guitar", "capo 2"],
  ["Standing Still", "Keyboards", "tune +2"],
  ["Sunspot Baby", "Harmonica", "D harmonica"],
  ["Take Me Home Country Roads", "Bass", "capo 2"],
  ["Take Me Home Country Roads", "Guitar", "capo 2"],
  ["Take Me Home Country Roads", "Keyboards", "tune +2"],
  ["The Old Man Down the Road", "Harmonica", "G harmonica"],
  ["Twilight Zone", "Bass", "Capo 2"],
  ["Twilight Zone", "Guitar", "Capo 2"],
  ["Twilight Zone", "Keyboards", "Tune up 2"],
  ["Zombie", "Bass", "capo 4"],
  ["Zombie", "Guitar", "capo 4"],
  ["Zombie", "Keyboards", "tune +4"]
]

preparation_keys = preparation_rows.map do |song_title, instrument_name, instruction|
  song = songs.fetch(song_title)
  instrument = instruments.fetch(instrument_name)
  preparation = Preparation.find_or_initialize_by(song: song, instrument: instrument)
  preparation.update!(instruction: instruction)
  [song.id, instrument.id]
end

Preparation.find_each do |preparation|
  next if preparation_keys.include?([preparation.song_id, preparation.instrument_id])

  preparation.destroy!
end

ListSong.delete_all
List.delete_all

setlists = [
  {
    name: "Standard 1",
    notes: "Set list we've been practicing with since 2025, suitable for opening a show.",
    songs: [
      "Folsom Prison Blues",
      "Down by the Water",
      "Summer of 69",
      "Like a Hurricane",
      "Manic Monday",
      "Californication",
      "Dead Flowers",
      "Running on Empty",
      "Better Man",
      "Southern Cross",
      "Have You Ever Seen the Rain",
      "I'm Eighteen",
      "Vacation",
      "Big Empty",
      "Come to my Window",
      "Melt With You",
      "Lonely Boy",
      "Wagon Wheel",
      "Twilight Zone"
    ]
  }
]

setlists.each do |setlist_attrs|
  setlist = band.lists.create!(
    name: setlist_attrs.fetch(:name),
    notes: setlist_attrs.fetch(:notes)
  )

  setlist_attrs.fetch(:songs).each_with_index do |title, index|
    setlist.list_songs.create!(
      song: songs.fetch(title),
      position: index + 1
    )
  end
end

admin = Player.find_or_initialize_by(email: admin_email)
admin.assign_attributes(
  first_name: "John",
  last_name: "Feltz",
  band: band,
  admin: true
)
admin.password = ENV.fetch("SEED_ADMIN_PASSWORD", "password") if admin.new_record? || admin.encrypted_password.blank?
admin.save!

Player.where.not(email: admin_email).find_each(&:destroy!)
