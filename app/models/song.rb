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
  # t.timestamps
##

class Song < ApplicationRecord
  # Statics & enums

  # Relations
  has_many :preparations
  belongs_to :band
  has_many :lists, through: :list_songs

  # Validations
  validates :title, presence: true

  # Scopes
  scope :alpha, -> { order(name: :asc) }
  scope :recent, -> { order(created_at: :desc) }

  # Class methods

  # Instance methods

  # Callbacks
end
