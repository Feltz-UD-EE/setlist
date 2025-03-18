#
# Copyright 2025 John C. Feltz, github: Feltz-UD-EE/setlist
#
# Band: a garage band with songs and set lists
  # t.string :name
  # t.timestamps
##

class Band < ApplicationRecord
  # Statics & enums

  # Relations
  # has_many :preparations...  complicated join
  has_many :players
  has_many :lists
  has_many :songs

  # Validations
  validates :name, presence: true

  # Scopes
  scope :alpha, -> { order(name: :asc) }

  # Class methods

  # Instance methods

  # Callbacks
end
