#
# Copyright 2025 John C. Feltz, github: Feltz-UD-EE/setlist
#
# Song: lyrics and music for a song (optional image upload)
  # t.string :title
  # t.string :version
  # t.string :performer
  # t.integer :duration
  # t.integer :tempo
  # t.string :intro
  # t.references :band
  # t.string :finish
  # t.timestamps
##

class Song < ApplicationRecord
  # Statics & enums

  # Relations
  has_many :preparations
  belongs_to :band
  has_many :list_songs
  has_many :lists, through: :list_songs

  # Validations
  validates :title, presence: true

  # Scopes
  scope :alpha, -> { order(title: :asc) }
  scope :recent, -> { order(created_at: :desc) }

  # Class methods

  # Instance methods
  def duration_pretty
    seconds = duration % 60
    minutes = (duration/60)
    return format("%2d:%02d", minutes, seconds)
  end
  # Callbacks
end
