#
# Copyright 2025 John C. Feltz, github: Feltz-UD-EE/setlist
#
# Player: A band member, who may play one or more instruments
  # t.string :instruction
  # t.references :song
  # t.references :instrument
  # t.timestamps
##

class Preparation < ApplicationRecord
  # Statics & enums

  # Relations
  belongs_to :song
  belongs_to :instrument

  # Validations
  validates :instruction, presence: true

  # Scopes

  # Class methods

  # Instance methods
  def with_instrument_name
    return "#{instrument.name}: #{instruction}"
  end

  # Callbacks
end
