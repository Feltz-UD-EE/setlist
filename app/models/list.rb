#
# Copyright 2025 John C. Feltz, github: Feltz-UD-EE/setlist
#
# List: A set list for performance or practice
#
  # t.string :name
  # t.string :notes
  # t.references :band
  # t.timestamps
##

class List < ApplicationRecord
  # Statics & enums

  # Relations
  belongs_to :band
  has_many :list_songs
  has_many :songs, -> { order('list_songs.position') }, through: :list_songs

  # Validations
  validates :name, presence: true

  # Scopes
  scope :alpha, -> { order(name: :asc) }
  scope :recent, -> { order(created_at: :desc) }

  # Class methods

  # Instance methods
  def runtime
    self.songs.sum(:duration)
  end

  def runtime_pretty
    seconds = runtime % 60
    minutes = (runtime / 60) % 60
    hours = runtime / 3600
    return format("%2d:%02d:%02d", hours, minutes, seconds)
  end
  # Callbacks
end
