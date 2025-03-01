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
  has_many :songs, through: :list_songs

  # Validations
  validates :name, presence: true

  # Scopes
  scope :alpha, -> { order(name: :asc) }
  scope :recent, -> { order(created_at: :desc) }

  # Class methods

  # Instance methods

  # Callbacks
end
