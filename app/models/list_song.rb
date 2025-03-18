#
# Copyright 2025 John C. Feltz, github: Feltz-UD-EE/setlist
#
# ListSong: join table with attributes
# t.references :list
# t.references :song
# t.integer :position
# t.timestamps
##
class ListSong < ApplicationRecord
  # Statics & enums

  # Relations
  belongs_to :list
  belongs_to :song

  # Validations
  validates :position, presence: true

  # Scopes

  # Class methods

  # Instance methods

  # Callbacks
end
