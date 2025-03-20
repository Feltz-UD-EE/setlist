require "application_system_test_case"

class PlaysTest < ApplicationSystemTestCase
  setup do
    @play = plays(:one)
  end

  test "visiting the index" do
    visit plays_url
    assert_selector "h1", text: "Plays"
  end

  test "should create play" do
    visit plays_url
    click_on "New play"

    click_on "Create Play"

    assert_text "Play was successfully created"
    click_on "Back"
  end

  test "should update Play" do
    visit play_url(@play)
    click_on "Edit this play", match: :first

    click_on "Update Play"

    assert_text "Play was successfully updated"
    click_on "Back"
  end

  test "should destroy Play" do
    visit play_url(@play)
    click_on "Destroy this play", match: :first

    assert_text "Play was successfully destroyed"
  end
end
