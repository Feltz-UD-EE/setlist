# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

drums = Instrument.create(name: "Drums")
drums2 = Instrument.create(name: "Drums 2")
bass = Instrument.create(name: "Bass")
guitar = Instrument.create(name: "Guitar")
guitar2 = Instrument.create(name: "Guitar 2")
keyboards = Instrument.create(name: "Keyboards")
keyboards2 = Instrument.create(name: "Keyboards 2")
vocals = Instrument.create(name: "Vocals")
vocals2 = Instrument.create(name: "Vocals 2")
harmonica = Instrument.create(name: "Harmonica")
saxophone = Instrument.create(name: "Saxophone")
trumpet = Instrument.create(name: "Trumpet")
trombone = Instrument.create(name: "Trombone")
engineer = Instrument.create(name: "Engineer")

b = Band.create(name: "Silver Lake Band")

s01 = b.songs.create(band_id: b.id, title: "Down by the Water", performer: "The Decembrists", duration: 180, intro: "Drums 2 measures", finish: "E minor")
s02 = b.songs.create(band_id: b.id, title: "Breakfast in America", performer: "Supertramp", duration: 200, intro: "Bass and keyboard 4 measures", finish: "A")
s03 = b.songs.create(band_id: b.id, title: "Like a Hurricane", performer: "Neal Young", duration: 180, intro: "Slow keyboard then harmonica", finish: "A")
s04 = b.songs.create(band_id: b.id, title: "Manic Monday", performer: "The Bangles", duration: 180, intro: "Drum count, all start", finish: "D")
s05 = b.songs.create(band_id: b.id, title: "Californication", performer: "Red Hot Chili Peppers", duration: 240, intro: "Bass and Casio", finish: "A minor")
s06 = b.songs.create(band_id: b.id, title: "Dead Flowers", performer: "The Rolling Stones", duration: 180, intro: "Drum count, all start", finish: "a capella")
s07 = b.songs.create(band_id: b.id, title: "Running on Empty", performer: "Jackson Brown", duration: 220, intro: "Keyboard and bass", finish: "A")
s08 = b.songs.create(band_id: b.id, title: "Better Man", performer: "Pearl Jam", duration: 200, intro: "Keyboard and plucked guitar", finish: "D")
s09 = b.songs.create(band_id: b.id, title: "Southern Cross", performer: "Crosby Stills & Nash", duration: 220, intro: "Drum count, all start", finish: "D")
s10 = b.songs.create(band_id: b.id, title: "Have You Ever Seen the Rain", performer: "Credence Clearwater Revival", duration: 160, intro: "Drum count, all start", finish: "C")
s11 = b.songs.create(band_id: b.id, title: "I'm Eighteen", performer: "Alice Cooper", duration: 180, intro: "Drum count, keyboard and harmonica", finish: "Extended harmonica C/D/E minor")
s12 = b.songs.create(band_id: b.id, title: "Vacation", performer: "The Go-Gos", duration: 200, intro: "Drum count, all start", finish: "E")
s13 = b.songs.create(band_id: b.id, title: "Big Empty", performer: "Stone Temple Pilots", duration: 180, intro: "Keyboard then guitar", finish: "E")
s14 = b.songs.create(band_id: b.id, title: "Lonely Boy", performer: "The Black Keys", duration: 200, intro: "Drum count, all start", finish: "A")
s15 = b.songs.create(band_id: b.id, title: "Wagon Wheel", performer: "Old Crow Medicine Show", duration: 180, intro: "Slow keyboard", finish: "a capella")
s16 = b.songs.create(band_id: b.id, title: "Keep on Rocking in the Free World", performer: "Neil Young", duration: 240, intro: "Drum count, all start", finish: "E")
s17 = b.songs.create(band_id: b.id, title: "You May be Right", performer: "Billy Joel", duration: 220, intro: "Drum count, all start", finish: "A")
s18 = b.songs.create(band_id: b.id, title: "Take it Easy", performer: "The Eagles", duration: 240, intro: "Drum count, all start", finish: "E minor")
s19 = b.songs.create(band_id: b.id, title: "Sunspot Baby", performer: "Bob Seger", duration: 180, intro: "Drum count, all start", finish: "E")
s20 = b.songs.create(band_id: b.id, title: "Eyes on the Prize", performer: "Bruce Springsteen", duration: 200, intro: "Keyboard", finish: "A minor")
s21 = b.songs.create(band_id: b.id, title: "The Old Man Down the Road", performer: "John Fogerty", duration: 180, intro: "Drum count, all start", finish: "Very slow vocal + C/D/E")
s22 = b.songs.create(band_id: b.id, title: "Sympathy for the Devil", performer: "The Rolling Stones", duration: 240, intro: "Keyboard and Vocals", finish: "E")
s23 = b.songs.create(band_id: b.id, title: "Rain on the Scarecrow", performer: "John Mellencamp", duration: 240, intro: "Keyboard", finish: "E minor")
s24 = b.songs.create(band_id: b.id, title: "Hold my Hand", performer: "Hootie and the Blowfish", duration: 200, intro: "Drum count, all start", finish: "A")
s25 = b.songs.create(band_id: b.id, title: "Rebel Yell", performer: "Billy Idol", duration: 180, intro: "Keyboard and plucked guitar", finish: "G (??)")
s26 = b.songs.create(band_id: b.id, title: "Twilight Zone", performer: "Golden Earring", duration: 300, intro: "Keyboard and guitar, then spoken word vocals", finish: "A minor")
s27 = b.songs.create(band_id: b.id, title: "Gimme Some Lovin", performer: "Spencer Davis Group", duration: 220, intro: "Drum count, keyboard and bass", finish: "G")
s28 = b.songs.create(band_id: b.id, title: "Melt With You", performer: "Modern English", duration: 220, intro: "Drum count, all start", finish: "C")

l1 = List.create(band_id: 1, name: "Rocking 1")
l2 = List.create(band_id: 1, name: "Rocking 2", notes: "In Progress")

Preparation.create(song_id: s01.id, instrument_id: harmonica.id, instruction: "G harmonica")

Preparation.create(song_id: s02.id, instrument_id: bass.id, instruction: "Capo 3")
Preparation.create(song_id: s02.id, instrument_id: guitar.id, instruction: "Capo 3")
Preparation.create(song_id: s02.id, instrument_id: keyboards.id, instruction: "Tune up 3")
Preparation.create(song_id: s02.id, instrument_id: harmonica.id, instruction: "C harmonica")

Preparation.create(song_id: s04.id, instrument_id: keyboards.id, instruction: "Casio mode X")

Preparation.create(song_id: s07.id, instrument_id: keyboards.id, instruction: "Casio mode X")

Preparation.create(song_id: s11.id, instrument_id: harmonica.id, instruction: "C harmonica")

Preparation.create(song_id: s14.id, instrument_id: harmonica.id, instruction: "G harmonica")

Preparation.create(song_id: s19.id, instrument_id: harmonica.id, instruction: "D harmonica")

Preparation.create(song_id: s20.id, instrument_id: harmonica.id, instruction: "C harmonica")
Preparation.create(song_id: s20.id, instrument_id: bass.id, instruction: "Capo 3")
Preparation.create(song_id: s20.id, instrument_id: guitar.id, instruction: "Capo 3")
Preparation.create(song_id: s20.id, instrument_id: keyboards.id, instruction: "Tune up 3")

Preparation.create(song_id: s21.id, instrument_id: harmonica.id, instruction: "G harmonica")

Preparation.create(song_id: s23.id, instrument_id: bass.id, instruction: "Capo 2")
Preparation.create(song_id: s23.id, instrument_id: guitar.id, instruction: "Capo 2")
Preparation.create(song_id: s23.id, instrument_id: keyboards.id, instruction: "Tune up 2")

Preparation.create(song_id: s24.id, instrument_id: bass.id, instruction: "Capo 2")
Preparation.create(song_id: s24.id, instrument_id: guitar.id, instruction: "Capo 2")
Preparation.create(song_id: s24.id, instrument_id: keyboards.id, instruction: "Tune up 2")

Preparation.create(song_id: s25.id, instrument_id: bass.id, instruction: "Capo 1")
Preparation.create(song_id: s25.id, instrument_id: guitar.id, instruction: "Capo 1")
Preparation.create(song_id: s25.id, instrument_id: keyboards.id, instruction: "Tune up 1")

Preparation.create(song_id: s26.id, instrument_id: bass.id, instruction: "Capo 2")
Preparation.create(song_id: s26.id, instrument_id: guitar.id, instruction: "Capo 2")
Preparation.create(song_id: s26.id, instrument_id: keyboards.id, instruction: "Tune up 2")

Preparation.create(song_id: s27.id, instrument_id: keyboards.id, instruction: "Casio mode X")

ls01 = ListSong.create(list_id: l1.id, song_id: s01.id, position: 1)
ls02 = ListSong.create(list_id: l1.id, song_id: s02.id, position: 2)
ls03 = ListSong.create(list_id: l1.id, song_id: s03.id, position: 3)
ls04 = ListSong.create(list_id: l1.id, song_id: s04.id, position: 4)
ls05 = ListSong.create(list_id: l1.id, song_id: s05.id, position: 5)
ls06 = ListSong.create(list_id: l1.id, song_id: s06.id, position: 6)
ls07 = ListSong.create(list_id: l1.id, song_id: s07.id, position: 7)
ls08 = ListSong.create(list_id: l1.id, song_id: s08.id, position: 8)
ls09 = ListSong.create(list_id: l1.id, song_id: s09.id, position: 9)
ls10 = ListSong.create(list_id: l1.id, song_id: s10.id, position: 10)
ls11 = ListSong.create(list_id: l1.id, song_id: s11.id, position: 11)
ls12 = ListSong.create(list_id: l1.id, song_id: s12.id, position: 12)
ls13 = ListSong.create(list_id: l1.id, song_id: s13.id, position: 13)
ls14 = ListSong.create(list_id: l1.id, song_id: s14.id, position: 14)
ls15 = ListSong.create(list_id: l1.id, song_id: s15.id, position: 15)
ls16 = ListSong.create(list_id: l1.id, song_id: s26.id, position: 16)
ls17 = ListSong.create(list_id: l2.id, song_id: s27.id, position: 1)
ls18 = ListSong.create(list_id: l2.id, song_id: s17.id, position: 2)
ls19 = ListSong.create(list_id: l2.id, song_id: s18.id, position: 3)
ls20 = ListSong.create(list_id: l2.id, song_id: s19.id, position: 4)
ls21 = ListSong.create(list_id: l2.id, song_id: s28.id, position: 5)
ls22 = ListSong.create(list_id: l2.id, song_id: s21.id, position: 6)
ls23 = ListSong.create(list_id: l2.id, song_id: s22.id, position: 7)
ls24 = ListSong.create(list_id: l2.id, song_id: s23.id, position: 8)
ls25 = ListSong.create(list_id: l2.id, song_id: s24.id, position: 9)
ls26 = ListSong.create(list_id: l2.id, song_id: s25.id, position: 10)
ls27 = ListSong.create(list_id: l2.id, song_id: s16.id, position: 11)

Player.create(first_name: "John", last_name: "Feltz", band_id: b.id, email: "john.feltz@gmail.com", password: "password")
Player.create(first_name: "Chip", last_name: "DeLong", band_id: b.id, email: "chipdelongmusic@gmail.com", password: "password")
Player.create(first_name: "Leo", last_name: "Kaske", band_id: b.id, email: "leokaske@gmail.com", password: "password")
Player.create(first_name: "Char", last_name: "Genger", band_id: b.id, email: "genglerc@aaps.k12.mi.us", password: "password")
Player.create(first_name: "John", last_name: "Machowicz", band_id: b.id, email: "john.machoqwicz@charter.net", password: "password")
Player.create(first_name: "Brian", last_name: "Mahnken", band_id: b.id, email: "mahnkenmi@hotmail.com", password: "password")
