require "test_helper"

class GigsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @band = Band.create!(name: "Gig Controller Band")
    @player = Player.create!(
      first_name: "Gig",
      last_name: "Tester",
      email: "gig-controller@example.com",
      password: "password123",
      band: @band
    )
    @player.bands << @band
    post session_url, params: { session: { email: @player.email, password: "password123" } }

    @first_list = List.create!(name: "First Set", band: @band)
    @second_list = List.create!(name: "Second Set", band: @band)
    @gig = Gig.create!(
      band: @band,
      booked_by: @player,
      date: Date.current + 1.day,
      client: "Client A",
      contact: "Contact A",
      fee: 500,
      start: "20:00"
    )
  end

  test "should get new" do
    get new_gig_url(band_id: @band.id)

    assert_response :success
    assert_select "h1", "Book a Gig"
  end

  test "creates upcoming gig with selected setlists and sends email" do
    assert_emails 1 do
      assert_difference("Gig.count", 1) do
        post gigs_url, params: {
          gig: {
            band_id: @band.id,
            date: Date.current + 2.days,
            client: "Client B",
            contact: "Contact B",
            fee: "750.00",
            start: "19:30"
          },
          gig_list_ids: [ @second_list.id, @first_list.id ]
        }
      end
    end

    gig = Gig.order(:created_at).last
    assert_redirected_to gig_url(gig)
    assert_equal [ @second_list.id, @first_list.id ], gig.gig_lists.order(:position).pluck(:list_id)
  end

  test "does not send email for past gig" do
    assert_no_emails do
      post gigs_url, params: {
        gig: {
          band_id: @band.id,
          date: Date.current - 2.days,
          client: "Past Client",
          contact: "Past Contact"
        }
      }
    end
  end

  test "updates setlist order" do
    patch gig_url(@gig), params: {
      gig: {
        band_id: @band.id,
        date: @gig.date,
        client: "Client A Updated",
        contact: @gig.contact,
        start: "20:00"
      },
      gig_list_ids: [ @first_list.id, @second_list.id ]
    }

    assert_redirected_to gig_url(@gig)
    assert_equal [ @first_list.id, @second_list.id ], @gig.reload.gig_lists.order(:position).pluck(:list_id)
  end

  test "shows only upcoming gigs on upcoming index" do
    Gig.create!(
      band: @band,
      booked_by: @player,
      date: Date.current - 1.day,
      client: "Past Hidden",
      contact: "Past Contact"
    )

    get upcoming_gigs_url(band_id: @band.id)

    assert_response :success
    assert_select "td", text: "Client A"
    assert_select "td", text: "Past Hidden", count: 0
  end

  test "saves retrospective for past gig" do
    past_gig = Gig.create!(
      band: @band,
      booked_by: @player,
      date: Date.current - 1.day,
      client: "Past Client",
      contact: "Past Contact"
    )

    patch retrospective_gig_url(past_gig), params: { gig: { retrospective: "Good room, easy load-in." } }

    assert_redirected_to gig_url(past_gig)
    assert_equal "Good room, easy load-in.", past_gig.reload.retrospective
  end

  test "rebook copies details and setlists without retrospective" do
    @gig.update!(retrospective: "Old notes", notes: "Load at side door")
    @gig.gig_lists.create!(list: @first_list, position: 1)

    assert_difference("Gig.count", 1) do
      post rebook_gig_url(@gig)
    end

    copied_gig = Gig.order(:created_at).last
    assert_redirected_to edit_gig_url(copied_gig, source_gig_id: @gig.id)
    assert_equal "Load at side door", copied_gig.notes
    assert_nil copied_gig.retrospective
    assert_equal @player, copied_gig.booked_by
    assert_equal Date.current, copied_gig.date
    assert_equal [ @first_list.id ], copied_gig.gig_lists.order(:position).pluck(:list_id)
  end
end
