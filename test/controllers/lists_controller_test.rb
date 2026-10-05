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

  test "show has randomize button" do
    list = List.create!(name: "Rocking 1", band: @band)

    get list_url(list)

    assert_response :success
    assert_select "form[action=?][method='post']", randomize_list_path(list) do
      assert_select "button", "Randomize"
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

    assert_redirected_to band_url(@band)
  end

  test "destroy removes gig assignments and redirects to band" do
    gig = Gig.create!(
      band: @band,
      booked_by: @player,
      date: Date.current + 1.day,
      client: "Wedding",
      contact: "Client"
    )
    gig.gig_lists.create!(list: @list, position: 1)

    assert_difference("GigList.count", -1) do
      assert_difference("List.count", -1) do
        delete list_url(@list)
      end
    end

    assert_redirected_to band_url(@band)
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

  test "randomize creates random setlist with same songs" do
    first_song = Song.create!(title: "First Song", band: @band)
    second_song = Song.create!(title: "Second Song", band: @band)
    list = List.create!(name: "Acoustic 1", band: @band)
    list.list_songs.create!(song: first_song, position: 1)
    list.list_songs.create!(song: second_song, position: 2)

    assert_difference("List.count", 1) do
      assert_difference("ListSong.count", 2) do
        post randomize_list_url(list)
      end
    end

    randomized_list = List.find_by!(band: @band, name: "Acoustic 1 random")
    assert_redirected_to list_url(randomized_list)
    assert_equal [ 1, 2 ], randomized_list.list_songs.order(:position).pluck(:position)
    assert_equal [ first_song.id, second_song.id ].sort, randomized_list.list_songs.pluck(:song_id).sort
  end

  test "randomize reuses existing random setlist and reshuffles songs" do
    first_song = Song.create!(title: "First Song", band: @band)
    second_song = Song.create!(title: "Second Song", band: @band)
    stale_song = Song.create!(title: "Stale Song", band: @band)
    list = List.create!(name: "Acoustic 1", band: @band)
    list.list_songs.create!(song: first_song, position: 1)
    list.list_songs.create!(song: second_song, position: 2)
    randomized_list = List.create!(name: "Acoustic 1 random", band: @band)
    randomized_list.list_songs.create!(song: stale_song, position: 1)

    assert_no_difference("List.count") do
      assert_difference("ListSong.count", 1) do
        post randomize_list_url(list)
      end
    end

    assert_redirected_to list_url(randomized_list)
    assert_equal [ 1, 2 ], randomized_list.reload.list_songs.order(:position).pluck(:position)
    assert_equal [ first_song.id, second_song.id ].sort, randomized_list.list_songs.pluck(:song_id).sort
  end
end
