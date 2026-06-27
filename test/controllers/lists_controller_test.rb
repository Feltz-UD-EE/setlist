require "test_helper"

class ListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @band = Band.create!(name: "Test Band")
    @player = Player.create!(
      first_name: "Test",
      last_name: "Player",
      email: "copy-test@example.com",
      password: "password123",
      band: @band
    )
    post session_url, params: { session: { email: @player.email, password: "password123" } }
    @list = List.create!(name: "Original Set", band: @band)
  end

  test "should get index" do
    get lists_url
    assert_response :success
  end

  test "should get new" do
    get new_list_url
    assert_response :success
  end

  test "should create list" do
    assert_difference("List.count") do
      post lists_url, params: { list: { name: "New Set", band_id: @band.id } }
    end

    assert_redirected_to list_url(List.last)
  end

  test "should show list" do
    get list_url(@list)
    assert_response :success
  end

  test "show has copy button" do
    list = List.create!(name: "Rocking 1", band: @band)

    get list_url(list)

    assert_response :success
    assert_select "form[action=?][method='post']", copy_list_path(list) do
      assert_select "button", "Copy"
    end
  end

  test "should get edit" do
    get edit_list_url(@list)
    assert_response :success
  end

  test "should update list" do
    patch list_url(@list), params: { list: { name: "Updated Set", band_id: @band.id } }
    assert_redirected_to list_url(@list)
  end

  test "should destroy list" do
    assert_difference("List.count", -1) do
      delete list_url(@list)
    end

    assert_redirected_to lists_url
  end

  test "copy creates editable duplicate with same songs in order" do
    first_song = Song.create!(title: "First Song", band: @band)
    second_song = Song.create!(title: "Second Song", band: @band)
    list = List.create!(name: "Rocking 1", notes: "Keep tight", band: @band)
    list.list_songs.create!(song: first_song, position: 1)
    list.list_songs.create!(song: second_song, position: 2)

    assert_difference("List.count", 1) do
      assert_difference("ListSong.count", 2) do
        post copy_list_url(list)
      end
    end

    copied_list = List.order(:created_at).last
    assert_redirected_to edit_list_url(copied_list)
    assert_equal "Copy of Rocking 1", copied_list.name
    assert_equal "Keep tight", copied_list.notes
    assert_equal @band, copied_list.band
    assert_equal [ first_song.id, second_song.id ], copied_list.list_songs.order(:position).pluck(:song_id)
  end
end
