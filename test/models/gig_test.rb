require "test_helper"

class GigTest < ActiveSupport::TestCase
  setup do
    @band = Band.create!(name: "Gig Model Band")
    @player = Player.create!(
      first_name: "Gig",
      last_name: "Booker",
      email: "gig-model@example.com",
      password: "password123",
      band: @band
    )
  end

  test "validates required fields" do
    gig = Gig.new

    assert_not gig.valid?
    assert_includes gig.errors[:date], "can't be blank"
    assert_includes gig.errors[:client], "can't be blank"
    assert_includes gig.errors[:contact], "can't be blank"
  end

  test "requires start when soundcheck is present" do
    gig = build_gig(soundcheck: "18:00", start: nil)

    assert_not gig.valid?
    assert_includes gig.errors[:start], "must be present when soundcheck is present"
  end

  test "validates time sequence" do
    gig = build_gig(soundcheck: "18:00", start: "17:30", end: "17:00")

    assert_not gig.valid?
    assert_includes gig.errors[:start], "must be later than soundcheck"
    assert_includes gig.errors[:end], "must be later than start"
  end

  test "requires all other gig times to be after load-in" do
    gig = build_gig(loadin: "18:00", soundcheck: "17:30", start: "17:45", end: "17:50")

    assert_not gig.valid?
    assert_includes gig.errors[:soundcheck], "must be later than load-in"
    assert_includes gig.errors[:start], "must be later than load-in"
    assert_includes gig.errors[:end], "must be later than load-in"
  end

  test "past and upcoming scopes split around today" do
    past_gig = build_gig(date: Date.current - 1.day, client: "Past Client")
    upcoming_gig = build_gig(date: Date.current, client: "Today Client")
    future_gig = build_gig(date: Date.current + 1.day, client: "Future Client")
    [ past_gig, upcoming_gig, future_gig ].each(&:save!)

    assert_equal [ past_gig.id ], Gig.past.pluck(:id)
    assert_equal [ upcoming_gig.id, future_gig.id ], Gig.upcoming.pluck(:id)
  end

  private

  def build_gig(attributes = {})
    Gig.new({
      band: @band,
      booked_by: @player,
      date: Date.current,
      client: "Client",
      contact: "Contact",
      start: "19:00"
    }.merge(attributes))
  end
end
