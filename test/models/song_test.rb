require "test_helper"

class SongTest < ActiveSupport::TestCase
  test "duration accepts seconds as text" do
    song = Song.new(duration: "245")

    assert_equal 245, song.duration
  end

  test "duration accepts minutes and seconds as text" do
    song = Song.new(duration: "4:05")

    assert_equal 245, song.duration
  end

  test "duration rejects unparseable text" do
    song = Song.new(title: "Test", duration: "four minutes")

    assert_not song.valid?
    assert_includes song.errors[:duration], "must be entered as seconds or mm:ss"
  end
end
