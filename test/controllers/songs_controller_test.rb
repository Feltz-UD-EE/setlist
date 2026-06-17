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
end
