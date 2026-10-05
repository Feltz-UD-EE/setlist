require "test_helper"

class SongsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @band = Band.create!(name: "Songs Controller Band")
    @player = Player.create!(
      first_name: "Songs",
      last_name: "Tester",
      email: "songs-controller@example.com",
      password: "password123",
      band: @band
    )
    @player.bands << @band
    post session_url, params: { session: { email: @player.email, password: "password123" } }
    @song = Song.create!(title: "Controller Test Song", band: @band, duration: 180)
  end

  test "should get index" do
    get songs_url
    assert_response :success
  end

  test "index truncates setlist names and displays song position outside the link" do
    list = List.create!(name: "A Very Long Setlist Name", band: @band)
    ListSong.create!(list: list, song: @song, position: 4)

    get songs_url

    assert_response :success
    assert_select "td", text: /A Very Long Setli\...\s+- #4/
    assert_select "a[href=?]", list_path(list), text: "A Very Long Setli..."
    assert_select "a[href=?]", list_path(list), text: "A Very Long Setli... - #4", count: 0
    assert_select "a[href=?]", list_path(list), text: "A Very Long Setlist Name", count: 0
  end

  test "index ignores setlist song rows without a setlist" do
    @song.list_songs.build(position: 1).save!(validate: false)

    get songs_url

    assert_response :success
    assert_select "td", text: "None"
  end

  test "should get band-scoped index when a song has no duration" do
    Song.create!(title: "No Duration Yet", band: @band, duration: nil)

    get songs_url(band_id: @band.id)

    assert_response :success
    assert_select "td", text: "No Duration Yet"
  end

  test "should get new" do
    get new_song_url(band_id: @band.id)
    assert_response :success
  end

  test "should create song" do
    assert_difference("Song.count") do
      post songs_url, params: { song: { title: "Created Song", band_id: @band.id } }
    end

    assert_redirected_to song_url(Song.last)
  end

  test "should show song" do
    get song_url(@song)
    assert_response :success
  end

  test "show links sheet thumbnails to stacked sheet pages" do
    main_sheet = create_sheet!("main-sheet.png", sort_order: 1)
    instrument = Instrument.create!(name: "Guitar")
    alternate_sheet = create_sheet!("guitar-sheet.png", sort_order: 1)
    SheetInstrument.create!(sheet: alternate_sheet, instrument: instrument)

    get song_url(@song)

    assert_response :success
    assert_select "a[href=?] img.song-sheet-thumb[src*=?]", sheets_song_path(@song), main_sheet.img.identifier
    assert_select "a[href=?] img.song-sheet-thumb[src*=?]", sheets_song_path(@song, instrument_id: instrument.id), alternate_sheet.img.identifier
  end

  test "sheets displays song name and main sheets stacked vertically" do
    create_sheet!("first-main-sheet.png", sort_order: 1)
    create_sheet!("second-main-sheet.png", sort_order: 2)

    get sheets_song_url(@song)

    assert_response :success
    assert_select "h1", text: @song.title
    assert_select ".song-sheets img.song-sheet-image", count: 2
    assert_select ".song-sheets img.song-sheet-image[src*=?]", "first-main-sheet.png"
    assert_select ".song-sheets img.song-sheet-image[src*=?]", "second-main-sheet.png"
  end

  test "sheets displays selected instrument sheets stacked vertically" do
    create_sheet!("main-sheet.png", sort_order: 1)
    guitar = Instrument.create!(name: "Guitar")
    bass = Instrument.create!(name: "Bass")
    guitar_sheet = create_sheet!("guitar-sheet.png", sort_order: 1)
    bass_sheet = create_sheet!("bass-sheet.png", sort_order: 1)
    SheetInstrument.create!(sheet: guitar_sheet, instrument: guitar)
    SheetInstrument.create!(sheet: bass_sheet, instrument: bass)

    get sheets_song_url(@song, instrument_id: guitar.id)

    assert_response :success
    assert_select "h1", text: @song.title
    assert_select ".alternate-image-label", text: /Guitar/
    assert_select ".song-sheets img.song-sheet-image", count: 1
    assert_select ".song-sheets img.song-sheet-image[src*=?]", "guitar-sheet.png"
    assert_select ".song-sheets img.song-sheet-image[src*=?]", "main-sheet.png", count: 0
    assert_select ".song-sheets img.song-sheet-image[src*=?]", "bass-sheet.png", count: 0
  end

  test "show truncates long setlist names" do
    list = List.create!(name: "A Very Long Setlist Name", band: @band)
    ListSong.create!(list: list, song: @song, position: 1)

    get song_url(@song)

    assert_response :success
    assert_select "a[href=?]", list_path(list), text: "A Very Long Setli..."
    assert_select "a[href=?]", list_path(list), text: "A Very Long Setlist Name", count: 0
  end

  test "show displays song position in each setlist outside the link" do
    list = List.create!(name: "Acoustic 1", band: @band)
    ListSong.create!(list: list, song: @song, position: 4)

    get song_url(@song)

    assert_response :success
    assert_select "p", text: /Acoustic 1\s+- #4/
    assert_select "a[href=?]", list_path(list), text: "Acoustic 1"
    assert_select "a[href=?]", list_path(list), text: "Acoustic 1 - #4", count: 0
  end

  test "show ignores setlist song rows without a setlist" do
    @song.list_songs.build(position: 1).save!(validate: false)

    get song_url(@song)

    assert_response :success
  end

  test "should get edit" do
    get edit_song_url(@song)
    assert_response :success
  end

  test "should update song" do
    patch song_url(@song), params: { song: { title: "Updated Song", band_id: @band.id } }
    assert_redirected_to song_url(@song)
  end

  test "should destroy song" do
    assert_difference("Song.count", -1) do
      delete song_url(@song)
    end

    assert_redirected_to songs_url
  end

  private

    def create_sheet!(filename, sort_order:)
      sheet = @song.sheets.build(sort_order: sort_order)
      sheet[:img] = filename
      sheet.save!
      sheet
    end
end
