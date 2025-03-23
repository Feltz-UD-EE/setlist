#
# Copyright 2025 John C. Feltz, github: Feltz-UD-EE/setlist
#
# Instrument: All instruments/vocal roles
#
  # t.string :name
  # t.timestamps
##

class Instrument < ApplicationRecord
  # Statics & enums

  # Relations
  has_many :preparations
  has_and_belongs_to_many :players
  has_many :pages

  # Validations
  validates :name, presence: true

  # Scopes
  scope :alpha, -> { order(name: :asc) }

  # Class methods

  # Instance methods

  # Callbacks

end
