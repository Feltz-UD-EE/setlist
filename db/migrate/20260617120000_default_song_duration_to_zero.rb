class DefaultSongDurationToZero < ActiveRecord::Migration[8.0]
  def up
    change_column_default :songs, :duration, from: nil, to: 0
    Song.where(duration: nil).update_all(duration: 0)
  end

  def down
    change_column_default :songs, :duration, from: 0, to: nil
  end
end
